part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.avatar,
    this.avatarPath,
    this.patient = Patient.empty,
  });

  final File? avatar;
  final String? avatarPath;
  final Patient patient;

  ProfileState copyWith({
    File? avatar,
    String? avatarPath,
    Patient? patient,
  }) {
    return ProfileState(
      avatar: avatar ?? this.avatar,
      avatarPath: avatarPath ?? this.avatarPath,
      patient: patient ?? this.patient,
    );
  }

  @override
  List<Object?> get props => [avatar, avatarPath, patient];
}
