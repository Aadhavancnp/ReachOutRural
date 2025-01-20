import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

part 'doctorinfo_state.dart';

class DoctorinfoCubit extends Cubit<DoctorinfoState> {
  DoctorinfoCubit(doctor, storageRepository)
      : _doctor = doctor,
        _storageRepository = storageRepository,
        super(const DoctorinfoState(
            isListening: false, recognizedText: '', locale: Locale('en')));

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final GoogleTranslator _translator = GoogleTranslator();
  final Doctor _doctor;
  final StorageRepository _storageRepository;

  Future<void> initializeLanguage() async {
    final locale =
        getLocaleFromCode(await _storageRepository.getLocale() ?? 'en');
    await _tts.setLanguage(locale.languageCode);
    await _tts.setSpeechRate(0.5);
    bool available = await _speechToText.initialize(
      onStatus: (status) => log('Speech recognition status: $status'),
      onError: (error) => log('Speech recognition error: $error'),
      debugLogging: true,
    );
    if (!available) {
      log('Speech recognition not available on this device');
    }
    emit(state.copyWith(locale: locale));
  }

  Future<void> toggleListening() async {
    if (_speechToText.isNotListening) {
      await startListening();
    } else {
      await stopListening();
    }
  }

  Future<void> startListening() async {
    emit(state.copyWith(isListening: true, recognizedText: ''));
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      localeId: state.locale.languageCode,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.search,
      ),
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    emit(state.copyWith(isListening: false, recognizedText: ''));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
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
      _executeCommand(translatedCommand);
    } catch (e) {
      _executeCommand(command);
    }
  }

  Future<void> _executeCommand(String command) async {
    if (command.contains('name')) {
      await _speak(_doctor.name);
    } else if (command.contains('bio')) {
      await _speak(_doctor.bio ?? 'Bio not available');
    } else if (command.contains('specialization') ||
        command.contains('specialisation') ||
        command.contains('specialty')) {
      await _speak(_doctor.specialization ?? 'Specialization not available');
    } else if (command.contains('location') || command.contains('address')) {
      await _speak(_doctor.location ?? 'Location not available');
    } else if (command.contains('daily timings')) {
      await _speak("Monday - Friday\nOpen till 7 Pm");
    } else if (command.contains('appointment') ||
        command.contains('book appointment')) {
      await stopListening();
      emit(state.copyWith(shouldNavigateToAppointments: true));
    } else if (command.contains('stop')) {
      await stopListening();
    } else {
      emit(state.copyWith(
          recognizedText: '',
          isListening: false,
          shouldNavigateToAppointments: false));
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
    await stopListening();
  }

  @override
  Future<void> close() {
    _speechToText.cancel();
    _tts.stop();
    return super.close();
  }
}
