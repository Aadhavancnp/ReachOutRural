import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/services/api/api_service.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required ApiService apiService,
    required StorageRepository storageRepository,
    required UserPatientRepository userPatientRepository,
  })  : _apiService = apiService,
        _storageRepository = storageRepository,
        _userPatientRepository = userPatientRepository,
        super(DashboardLoading());

  final ApiService _apiService;
  final StorageRepository _storageRepository;
  final UserPatientRepository _userPatientRepository;

  @override
  void emit(DashboardState state) {
    if (isClosed) return;
    super.emit(state);
  }

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final doctors = await _loadDoctors();
      final hospitals = await _loadHospitals();

      emit(DashboardLoaded(doctors: doctors, hospitals: hospitals));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<List<Doctor>> _loadDoctors() async {
    final doctors = await _storageRepository.getDoctors();
    if (doctors.isNotEmpty) {
      return doctors;
    }

    final fetchDoctors = await _apiService.getDoctors();
    await _storageRepository.saveDoctors(fetchDoctors);
    return fetchDoctors;
  }

  Future<List<Hospital>> _loadHospitals() async {
    final hospitals = await _storageRepository.getHospitals();
    if (hospitals.isNotEmpty) {
      return hospitals;
    }

    final user = await _userPatientRepository.getUserPatient();

    final fetchHospitals = await _apiService.getNearbyHospitals(user!.phone);
    await _storageRepository.saveHospitals(fetchHospitals);
    return fetchHospitals;
  }

  Future<void> refreshDashboardData() async {
    try {
      final user = await _userPatientRepository.getUserPatient();
      final doctors = await _apiService.getDoctors();
      final hospitals = await _apiService.getNearbyHospitals(user!.phone);

      await _storageRepository.removeDoctors();
      await _storageRepository.saveDoctors(doctors);

      await _storageRepository.removeHospitals();
      await _storageRepository.saveHospitals(hospitals);

      emit(DashboardLoaded(doctors: doctors, hospitals: hospitals));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
