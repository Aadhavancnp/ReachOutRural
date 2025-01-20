part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.phone = const Phone.pure(),
    this.isValid = false,
    this.errorMsg = '',
  });

  final FormzSubmissionStatus status;
  final Phone phone;
  final String errorMsg;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Phone? phone,
    String? errorMsg,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      errorMsg: errorMsg ?? this.errorMsg,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, phone, errorMsg];
}
