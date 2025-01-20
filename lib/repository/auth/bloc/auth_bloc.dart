import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reach_out_rural/models/patient.dart';

import '../../user/user_patient_repository.dart';
import '../auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthenticationRepository authenticationRepository,
    required UserPatientRepository userPatientRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userPatientRepository = userPatientRepository,
        super(const AuthState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<UserUpdated>(_onUserUpdated);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserPatientRepository _userPatientRepository;

  void _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) {
    emit(AuthState.authenticated(event.user));
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final userPatient = await _tryGetUserPatient();
            return emit(
              userPatient != null
                  ? AuthState.authenticated(userPatient)
                  : const AuthState.unauthenticated(),
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  Future<Patient?> _tryGetUserPatient() async {
    try {
      final userPatient = await _userPatientRepository.getUserPatient();
      return userPatient;
    } catch (_) {
      return null;
    }
  }
}
