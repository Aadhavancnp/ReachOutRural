part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


final class PhoneChanged extends LoginEvent {
  const PhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}