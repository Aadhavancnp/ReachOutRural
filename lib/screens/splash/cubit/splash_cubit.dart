import 'package:bloc/bloc.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit({
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        super(false);

  final StorageRepository _storageRepository;

  Future<void> checkSplashSeen() async {
    final hasSeenSplash = await _storageRepository.isSplashScreenShown();
    emit(hasSeenSplash!);
  }

  Future<void> markSplashAsSeen() async {
    await _storageRepository.setSplashScreenShown();
    emit(true);
  }
}
