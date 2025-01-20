part of 'scanner_bloc.dart';

sealed class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object> get props => [];
}

final class ScannerInitial extends ScannerState {}

final class ScannerReady extends ScannerState {
  final CameraController controller;
  final FlashMode flashMode;

  const ScannerReady(this.controller, this.flashMode);

  @override
  List<Object> get props => [controller, flashMode];
}

final class ScannerError extends ScannerState {
  final String message;
  const ScannerError({required this.message});
}

final class ScannerPictureTaken extends ScannerState {
  final String imagePath;
  const ScannerPictureTaken(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
