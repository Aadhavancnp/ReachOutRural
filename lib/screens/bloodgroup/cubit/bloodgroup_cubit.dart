import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';

class BloodgroupCubit extends Cubit<int> {
  BloodgroupCubit({
    required UserPatientRepository userPatientRepository,
  })  : _userPatientRepository = userPatientRepository,
        super(0);

  final UserPatientRepository _userPatientRepository;

  void selectPage(int currentPage) => emit(currentPage);

  void setUserPatientBloodgroup(int bloodgroup) async {
    final patient = await _userPatientRepository.getUserPatient();
    final bloodgroupName = bloodGroupNames[bloodgroup];
    final bloodGroup = bloodgroupName!.first as BloodGroup;
    final bloodGroupType = bloodgroupName.last as BloodGroupType;
    await _userPatientRepository.saveUserPatient(patient!
        .copyWith(bloodGroup: bloodGroup, bloodGroupType: bloodGroupType));
  }
}
