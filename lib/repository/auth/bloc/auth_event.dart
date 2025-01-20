part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthenticationSubscriptionRequested extends AuthEvent {}

final class AuthenticationLogoutPressed extends AuthEvent {}

class UserUpdated extends AuthEvent {
  final Patient user;
  const UserUpdated(this.user);
}

