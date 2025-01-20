part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.userPatient = Patient.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(Patient userPatient)
      : this._(
            status: AuthenticationStatus.authenticated,
            userPatient: userPatient);

  const AuthState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final Patient userPatient;

  @override
  List<Object> get props => [status, userPatient];
}
