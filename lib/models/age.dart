import 'package:formz/formz.dart';

enum AgeValidationError { empty }

class Age extends FormzInput<int, AgeValidationError> {
  const Age.pure() : super.pure(7);
  const Age.dirty([super.value = 7]) : super.dirty();

  @override
  AgeValidationError? validator(int value) {
    if (value < 7) return AgeValidationError.empty;
    return null;
  }
}
