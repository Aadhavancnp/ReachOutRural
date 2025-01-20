import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

class GenderCubit extends Cubit<Gender> {
  GenderCubit({required UserPatientRepository userPatientRepository})
      : _userPatientRepository = userPatientRepository,
        super(Gender.male);
  final UserPatientRepository _userPatientRepository;

  void selectGender(Gender newGender) => emit(newGender);

  void setUserPatientGender(Gender gender) async {
    final patient = await _userPatientRepository.getUserPatient();
    await _userPatientRepository
        .saveUserPatient(patient!.copyWith(gender: gender));
  }
}
