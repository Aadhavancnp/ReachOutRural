import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

class WeightCubit extends Cubit<double> {
  WeightCubit({required UserPatientRepository userPatientRepository})
      : _userPatientRepository = userPatientRepository,
        super(40.0);

  final UserPatientRepository _userPatientRepository;

  void selectWeight(double newWeight) => emit(newWeight);

  void setUserPatientWeight(double weight) async {
    final patient = await _userPatientRepository.getUserPatient();
    await _userPatientRepository
        .saveUserPatient(patient!.copyWith(weight: weight.toString()));
  }
}
