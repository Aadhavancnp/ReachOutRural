import 'package:formz/formz.dart';

enum LocationValidationError { empty }

class Location extends FormzInput<String, LocationValidationError> {
  const Location.pure() : super.pure('');
  const Location.dirty([super.value = '']) : super.dirty();

  @override
  LocationValidationError? validator(String value) {
    if (value.isEmpty) return LocationValidationError.empty;
    return null;
  }
}
