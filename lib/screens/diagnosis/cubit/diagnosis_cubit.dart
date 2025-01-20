import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'diagnosis_state.dart';

class DiagnosisCubit extends Cubit<DiagnosisState> {
  DiagnosisCubit({required UserPatientRepository userPatientRepository})
      : _userPatientRepository = userPatientRepository,
        super(const DiagnosisState(
          isListening: false,
          text: '',
        ));

  final UserPatientRepository _userPatientRepository;

  final SpeechToText _speechToText = SpeechToText();
  Timer? _listenTimer;

  void listen() async {
    if (!state.isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (statusNotification) =>
            log('onStatus: $statusNotification'),
        onError: (errorNotification) => log('onError: $errorNotification'),
      );
      if (available) {
        emit(DiagnosisState(isListening: true, text: state.text));
        await _speechToText.listen(
            onResult: (result) {
              emit(DiagnosisState(
                isListening: true,
                text: result.recognizedWords,
              ));
              _resetSilenceTimer();
            },
            pauseFor: const Duration(seconds: 3),
            listenFor: const Duration(seconds: 10),
            listenOptions: SpeechListenOptions(
              listenMode: ListenMode.confirmation,
              partialResults: false,
              onDevice: true,
              cancelOnError: true,
            ));
      }
    } else {
      stopListening();
    }
  }

  void _resetSilenceTimer() {
    _listenTimer?.cancel();
    _listenTimer = Timer(const Duration(seconds: 2), () {
      if (state.isListening) {
        stopListening();
      }
    });
  }

  void stopListening() async {
    await _speechToText.stop();
    _listenTimer?.cancel();
    emit(DiagnosisState(isListening: false, text: state.text));
  }

  @override
  Future<void> close() {
    _speechToText.cancel();
    _listenTimer?.cancel();

    return super.close();
  }

  void setUserPatientDiagnosis() async {
    final patient = await _userPatientRepository.getUserPatient();
    await _userPatientRepository
        .saveUserPatient(patient!.copyWith(bio: state.text));
  }
}
