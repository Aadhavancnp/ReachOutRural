part of 'editprofile_cubit.dart';

class EditprofileState extends Equatable {
  const EditprofileState({
    this.status = FormzSubmissionStatus.initial,
    this.name = const Name.pure(),
    this.phone = const Phone.pure(),
    this.email = const Email.pure(),
    this.age = const Age.pure(),
    this.location = const Location.pure(),
    this.errorMsg = '',
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Name name;
  final Phone phone;
  final Email email;
  final Age age;
  final Location location;
  final String errorMsg;
  final bool isValid;

  EditprofileState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    Phone? phone,
    Email? email,
    Age? age,
    Location? location,
    String? errorMsg,
    bool? isValid,
  }) {
    return EditprofileState(
      status: status ?? this.status,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      age: age ?? this.age,
      location: location ?? this.location,
      errorMsg: errorMsg ?? this.errorMsg,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        name,
        phone,
        email,
        age,
        location,
        errorMsg,
      ];
}
