import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

class HeightCubit extends Cubit<num> {
  HeightCubit({required UserPatientRepository userPatientRepository})
      : _userPatientRepository = userPatientRepository,
        super(40);

  final UserPatientRepository _userPatientRepository;

  void selectHeight(num newHeight) => emit(newHeight);

  void setUserPatientHeight(num height) async {
    final patient = await _userPatientRepository.getUserPatient();
    await _userPatientRepository
        .saveUserPatient(patient!.copyWith(height: height.toString()));
  }
}
