import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:geocoding/geocoding.dart' as loc;
import 'package:reach_out_rural/models/age.dart';
import 'package:reach_out_rural/models/email.dart';
import 'package:reach_out_rural/models/location.dart';
import 'package:reach_out_rural/models/name.dart';
import 'package:reach_out_rural/models/phone.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/services/api/api_service.dart';

part 'editprofile_state.dart';

class EditprofileCubit extends Cubit<EditprofileState> {
  EditprofileCubit({
    required UserPatientRepository userPatientRepository,
    required ApiService apiService,
    required AuthBloc authBloc,
  })  : _userPatientRepository = userPatientRepository,
        _apiService = apiService,
        _authBloc = authBloc,
        super(const EditprofileState()) {
    init();
  }

  final ApiService _apiService;
  final UserPatientRepository _userPatientRepository;
  final AuthBloc _authBloc;

  void init() async {
    final patient = await _userPatientRepository.getUserPatient();
    emit(
      state.copyWith(
        name: Name.dirty(patient!.name),
        phone: Phone.dirty(patient.phone),
        email: Email.dirty(patient.email),
        age: Age.dirty(patient.age),
        location: Location.dirty(patient.location),
        isValid: Formz.validate([
          Name.dirty(patient.name),
          Phone.dirty(patient.phone),
          Email.dirty(patient.email),
          Age.dirty(patient.age),
          Location.dirty(patient.location),
        ]),
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([
          name,
          // state.phone,
          // state.email,
          // state.age,
          // state.location,
        ]),
      ),
    );
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate([
          // state.name,
          phone,
          // state.email,
          // state.age,
          // state.location,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          // state.name,
          // state.phone,
          email,
          // state.age,
          // state.location,
        ]),
      ),
    );
  }

  void ageChanged(int value) {
    final age = Age.dirty(value);
    emit(
      state.copyWith(
        age: age,
        isValid: Formz.validate([
          // state.name,
          // state.phone,
          // state.email,
          age,
          // state.location,
        ]),
      ),
    );
  }

  void locationChanged(String value) {
    final location = Location.dirty(value);
    emit(
      state.copyWith(
        location: location,
        isValid: Formz.validate([
          // state.name,
          // state.phone,
          // state.email,
          // state.age,
          location,
        ]),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final patient = await _userPatientRepository.getUserPatient();
        final List<loc.Location> locations = await loc.locationFromAddress(
            state.location.value.isEmpty
                ? patient!.location
                : state.location.value);
        final userData = patient!.copyWith(
          name: state.name.value,
          phone: state.phone.value,
          email: state.email.value,
          age: state.age.value,
          location: state.location.value,
          latitude: locations[0].latitude.toString(),
          longitude: locations[0].longitude.toString(),
        );
        final userDataJson = userData.toJson();
        userDataJson["height"] = double.tryParse(userDataJson["height"]) ?? 0;
        userDataJson["weight"] = double.tryParse(userDataJson["weight"]) ?? 0;

        await _apiService.updateProfile(userDataJson);
        await _userPatientRepository.saveUserPatient(userData);
        _authBloc.add(UserUpdated(userData));
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
