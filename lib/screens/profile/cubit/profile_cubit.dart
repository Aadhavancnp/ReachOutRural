import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserPatientRepository userPatientRepository,
  })  : _userPatientRepository = userPatientRepository,
        super(const ProfileState()) {
    init();
  }

  final UserPatientRepository _userPatientRepository;

  void init() async {
    final patient = await _userPatientRepository.getUserPatient();
    emit(state.copyWith(patient: patient));
  }

  Future<void> pickImage() async {
    final picker = await FilePicker.platform.pickFiles(type: FileType.image);
    final pickedFile = picker?.files.first;
    if (pickedFile != null) {
      emit(state.copyWith(avatarPath: pickedFile.path));
    }
  }

  Future<void> saveAvatar() async {
    await _userPatientRepository.getUserPatient();
    // await _userPatientRepository.saveUserPatient(
    //   patient!.copyWith(avatar: File(state.avatarPath)),
    // );
  }
}
