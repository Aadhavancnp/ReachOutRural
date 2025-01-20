import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/services/api/api_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ApiService apiService,
    required StorageRepository storageRepository,
    required UserPatientRepository userPatientRepository,
    required AuthBloc authBloc,
  })  : _apiService = apiService,
        _storageRepository = storageRepository,
        _userPatientRepository = userPatientRepository,
        _authBloc = authBloc,
        super(const HomeState());

  final AuthBloc _authBloc;
  final ApiService _apiService;
  final StorageRepository _storageRepository;
  final UserPatientRepository _userPatientRepository;
  final SpeechToText _speechToText = SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();
  StreamSubscription<Position>? _positionStreamSubscription;
  final chatCubitStreamController = StreamController<String>.broadcast();

  Future<void> initializeApp() async {
    final locale = await _storageRepository.getLocale();
    if (locale == null) {
      await _storageRepository.saveLocale('en');
    }
    bool available = await _speechToText.initialize(
      onStatus: (status) => log('Speech recognition status: $status'),
      onError: (error) => log('Speech recognition error: $error'),
      debugLogging: true,
    );
    if (!available) {
      log('Speech recognition not available on this device');
    }
    await _checkAndRequestLocationPermission();
    await _checkAndRequestPermissions();
    emit(state.copyWith(locale: Locale(locale!)));
  }

  void changeIndex(int index) => emit(state.copyWith(currentIndex: index));

  Future<void> _checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.photos,
    ].request();

    if (statuses[Permission.microphone]!.isPermanentlyDenied ||
        statuses[Permission.microphone]!.isDenied) {
      emit(state.copyWith(
          permissionEvent:
              ShowPermissionDeniedDialog('Microphone', Permission.microphone)));
    }
    if (statuses[Permission.camera]!.isPermanentlyDenied ||
        statuses[Permission.camera]!.isDenied) {
      emit(state.copyWith(
          permissionEvent:
              ShowPermissionDeniedDialog('Camera', Permission.camera)));
    }
    if (statuses[Permission.location]!.isPermanentlyDenied ||
        statuses[Permission.locationWhenInUse]!.isPermanentlyDenied ||
        statuses[Permission.location]!.isDenied ||
        statuses[Permission.locationWhenInUse]!.isDenied) {
      emit(state.copyWith(
          permissionEvent:
              ShowPermissionDeniedDialog('Location', Permission.location)));
    }
    if (statuses[Permission.photos]!.isPermanentlyDenied ||
        statuses[Permission.photos]!.isDenied) {
      emit(state.copyWith(
          permissionEvent:
              ShowPermissionDeniedDialog('Photos', Permission.photos)));
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(
        permissionEvent: ShowLocationServiceDisabledDialog(),
      ));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
          permissionEvent: ShowLocationPermissionDeniedDialog(),
        ));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
        permissionEvent: ShowLocationPermissionPermanentlyDeniedDialog(),
      ));
      return;
    }

    // If we reach here, location permission is granted
    await _initializeLocationServices();
  }

  Future<void> _initializeLocationServices() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(currentPosition: position));
      _startLocationUpdates();
    } catch (e) {
      log('Error getting location: $e');
      emit(state.copyWith(
        permissionEvent: ShowLocationErrorDialog(e.toString()),
      ));
    }
  }

  void clearPermissionEvent() {
    emit(state.copyWith(permissionEvent: null));
  }

  Future<void> toggleListening() async {
    if (_speechToText.isNotListening) {
      await startListening();
    } else {
      await stopListening();
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    emit(state.copyWith(isListening: false, recognizedText: ''));
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      emit(state.copyWith(currentPosition: position));
      _updateLocationForUser(position);
    });
  }

  Future<void> retryLocationInitialization() async {
    emit(state.copyWith(permissionEvent: null));
    await _checkAndRequestLocationPermission();
  }

  void _updateLocationForUser(Position position) async {
    var patient = await _userPatientRepository.getUserPatient();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String address = '${place.street}, ${place.locality}, ${place.country}';
    patient = patient!.copyWith(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      location: address,
    );
    final userDataJson = patient.toJson();
    userDataJson["height"] = double.tryParse(userDataJson["height"]) ?? 0;
    userDataJson["weight"] = double.tryParse(userDataJson["weight"]) ?? 0;
    userDataJson["bloodgroup"] = userDataJson["bloodgroup"].toString() +
        (userDataJson["bloodgroupType"] == "positive" ? "+" : "-");
    await _apiService.updateProfile(userDataJson);
    await _userPatientRepository.saveUserPatient(patient);
    _authBloc.add(UserUpdated(patient));
  }

  Future<void> startListening() async {
    emit(state.copyWith(isListening: true, recognizedText: ''));
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        partialResults: false,
        listenMode: ListenMode.search,
      ),
      localeId: state.locale?.languageCode,
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      final command = result.recognizedWords.toLowerCase();
      emit(state.copyWith(recognizedText: command));
      _processCommand(command);
    }
  }

  Future<void> _processCommand(String command) async {
    try {
      final translation = await _translator.translate(command, to: 'en');
      final translatedCommand = translation.text.toLowerCase();
      final detectedLanguage = _detectLanguage(translatedCommand);
      if (detectedLanguage != null) {
        changeLanguage(detectedLanguage);
      } else {
        _executeCommand(translatedCommand);
      }
    } catch (e) {
      _executeCommand(command);
    }
  }

  void _executeCommand(String command) async {
    if (command.contains('stop')) {
      await stopListening();
    } else {
      final response = await _apiService.checkNavigation({"query": command});
      if (response.data["error"] == null) {
        _handleNavigation(response.data["category"], command);
      }
    }
  }

  void _handleNavigation(String category, String command) {
    switch (category) {
      case "home":
        changeIndex(0);
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "medibot":
        changeIndex(1);
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "mediscanner":
        changeIndex(2);
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "community":
        changeIndex(3);
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "edit_profile":
        editProfile();
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "search_doctor":
        searchDoctor();
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "book_appointment":
        bookAppointment();
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "user_profile":
        userProfile();
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      case "upload_prescription":
        uploadPrescription();
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
      default:
        emit(state.copyWith(
          recognizedText: '',
          isListening: false,
        ));
        break;
    }
  }

  Future<void> editProfile() async {
    final patient = await _userPatientRepository.getUserPatient();
    if (patient != null) {
      final List<Location> locations =
          await locationFromAddress(patient.location)
              .catchError((e) => <Location>[]);
      final location = locations.isNotEmpty ? locations.first : null;
      if (location != null) {
        final placeList = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        final place = placeList.isNotEmpty ? placeList.first : null;
        final address = place != null
            ? "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}"
            : '';
        final patientData = patient.copyWith(
          location: address,
          latitude: location.latitude.toString(),
          longitude: location.longitude.toString(),
        );
        await _userPatientRepository.saveUserPatient(patientData);
      }
    }
    emit(state.copyWith(nextPath: '/edit-profile'));
  }

  String? _detectLanguage(String command) {
    for (var entry in languageMap.entries) {
      if (command.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return null;
  }

  void changeLanguage(String languageCode) async {
    await _storageRepository.saveLocale(languageCode);
    emit(state.copyWith(
        locale: Locale(languageCode), recognizedText: '', isListening: false));
  }

  void searchDoctor() async {
    emit(state.copyWith(nextPath: '/search-doctor'));
  }

  void bookAppointment() async {
    emit(state.copyWith(nextPath: '/appointments'));
  }

  void userProfile() async {
    emit(state.copyWith(nextPath: '/profile'));
  }

  void uploadPrescription() async {
    emit(state.copyWith(nextPath: '/upload-prescription'));
  }

  @override
  Future<void> close() {
    chatCubitStreamController.close();
    _positionStreamSubscription?.cancel();
    _speechToText.cancel();
    return super.close();
  }
}
