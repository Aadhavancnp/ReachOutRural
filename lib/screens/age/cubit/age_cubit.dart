import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

class AgeCubit extends Cubit<int> {
  AgeCubit({required UserPatientRepository userPatientRepository})
      : _userPatientRepository = userPatientRepository,
        super(18);
  final UserPatientRepository _userPatientRepository;

  void selectAge(int newAge) => emit(newAge);

  void setUserPatientAge(int age) async {
    final patient = await _userPatientRepository.getUserPatient();
    await _userPatientRepository.saveUserPatient(patient!.copyWith(age: age));
  }
}
