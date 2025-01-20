import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reach_out_rural/services/api/api_service.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc({
    required ApiService apiService,
  })  : _apiService = apiService,
        super(ScannerInitial()) {
    on<CameraInitializedEvent>(_initializeCamera);
    on<TakePictureEvent>(_takePicture);
    on<ToggleFlashEvent>(_toggleFlash);
  }

  final ApiService _apiService;
  late CameraController _controller;
  FlashMode _flashMode = FlashMode.off;

  Future<void> _toggleFlash(
      ToggleFlashEvent event, Emitter<ScannerState> emit) async {
    try {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else {
        _flashMode = FlashMode.off;
      }
      await _controller.setFlashMode(_flashMode);
      emit(ScannerReady(_controller, _flashMode));
    } catch (e) {
      emit(ScannerError(message: 'Error toggling flash: $e'));
    }
  }

  Future<void> _takePicture(
      TakePictureEvent event, Emitter<ScannerState> emit) async {
    try {
      final image = await _controller.takePicture();
      emit(ScannerPictureTaken(image.path));
    } catch (e) {
      emit(ScannerError(message: 'Error taking picture: $e'));
    }
  }

  Future<void> _initializeCamera(
      CameraInitializedEvent event, Emitter<ScannerState> emit) async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.max);
      await _controller.initialize();
      await _controller.setFlashMode(_flashMode);
      emit(ScannerReady(_controller, _flashMode));
    } catch (e) {
      emit(ScannerError(message: 'Error initializing camera: $e'));
    }
  }

  Future<String> scanSkin(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      final response = await _apiService.predict(formData);
      if (response.data['error'] != null) {
        return response.data['error'];
      }
      return response.data['condition'];
    } catch (e) {
      return 'Error scanning skin: $e';
    }
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
