part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.phone = const Phone.pure(),
    this.isValid = false,
    this.errorMsg = '',
  });

  final FormzSubmissionStatus status;
  final Phone phone;
  final String errorMsg;
  final bool isValid;

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Phone? phone,
    String? errorMsg,
    bool? isValid,
  }) {
    return RegisterState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      errorMsg: errorMsg ?? this.errorMsg,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, phone, errorMsg];
}
