import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:reach_out_rural/constants/auth_exceptions.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/repository/auth/auth_repository.dart';
import 'package:reach_out_rural/models/phone.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
    required UserPatientRepository userPatientRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userPatientRepository = userPatientRepository,
        super(const LoginState()) {
    on<PhoneChanged>(_onPhoneChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserPatientRepository _userPatientRepository;

  void _onPhoneChanged(
    PhoneChanged event,
    Emitter<LoginState> emit,
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
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logIn(
          phone: state.phone.value,
        );
        final userPatient =
            await _userPatientRepository.getUserPatient() ?? Patient.empty;
        await _userPatientRepository.saveUserPatient(
          userPatient.copyWith(phone: state.phone.value),
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on LogInException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMsg: e.message,
        ));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
