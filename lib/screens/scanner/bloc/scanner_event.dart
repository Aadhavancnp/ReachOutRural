part of 'scanner_bloc.dart';

sealed class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}


class CameraInitializedEvent extends ScannerEvent {}

class TakePictureEvent extends ScannerEvent {}

class ToggleFlashEvent extends ScannerEvent {}