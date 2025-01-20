part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterPhoneChanged extends RegisterEvent {
  const RegisterPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
