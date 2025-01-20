import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:reach_out_rural/constants/auth_exceptions.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/repository/auth/auth_repository.dart';
import 'package:reach_out_rural/models/phone.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationRepository authenticationRepository,
    required UserPatientRepository userPatientRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userPatientRepository = userPatientRepository,
        super(const RegisterState()) {
    on<RegisterPhoneChanged>(_onPhoneChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserPatientRepository _userPatientRepository;

  void _onPhoneChanged(
    RegisterPhoneChanged event,
    Emitter<RegisterState> emit,
  ) {
    final phone = Phone.dirty(event.phone);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate([phone]),
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.register(
          phone: state.phone.value,
        );
        final userPatient =
            await _userPatientRepository.getUserPatient() ?? Patient.empty;
        await _userPatientRepository.saveUserPatient(
          userPatient.copyWith(phone: state.phone.value),
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on SignUpException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMsg: e.message,
        ));
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
