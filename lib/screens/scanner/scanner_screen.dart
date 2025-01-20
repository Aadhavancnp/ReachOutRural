import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

// class ScannerScreen extends StatelessWidget {
//   const ScannerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     void showScanResultDialog(String result) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Scan Result"),
//           content: Text(result),
//           actions: [
//             TextButton(
//               onPressed: () => context.pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }

//     final toaster = ToastHelper(context);

//     return BlocProvider(
//       create: (context) => ScannerBloc(apiService: context.read<ApiService>())
//         ..add(CameraInitializedEvent()),
//       child: BlocConsumer<ScannerBloc, ScannerState>(
//           listener: (context, state) async {
//         if (state is ScannerPictureTaken) {
//           final res =
//               await context.push('/analysis', extra: state.imagePath) as String;
//           showScanResultDialog(res);
//         } else if (state is ScannerError) {
//           toaster.showErrorToast(state.message);
//         }
//       }, builder: (context, state) {
//         if (state is ScannerReady) {
//           return Scaffold(
//             body: SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: AspectRatio(
//                   aspectRatio: 9.0 / 16.0,
//                   child: CameraPreview(state.controller),
//                 )),
//             floatingActionButton: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'toggleFlash',
//                   onPressed: () =>
//                       context.read<ScannerBloc>().add(ToggleFlashEvent()),
//                   child: Icon(state.flashMode == FlashMode.off
//                       ? Iconsax.flash_slash
//                       : Iconsax.flash_1),
//                 ),
//                 const SizedBox(height: 15),
//                 FloatingActionButton(
//                   heroTag: 'scanSkin',
//                   onPressed: () {
//                     context.read<ScannerBloc>().add(TakePictureEvent());
//                   },
//                   child: const Icon(Iconsax.camera),
//                 ),
//               ],
//             ),
//           );
//         } else if (state is ScannerError) {
//           return Scaffold(body: Center(child: Text('Error: ${state.message}')));
//         } else {
//           return const Scaffold(
//               body: Center(child: CircularProgressIndicator()));
//         }
//       }),
//     );
//   }
// }

import 'dart:developer';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      log('Error initializing camera: $e');
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller!.value.isInitialized) {
      log('Camera controller is not initialized');
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _scanSkin() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      log('Camera controller is not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      final res = await context.push('/analysis', extra: image.path) as List?;
      if (res != null) {
        _showScanResultDialog(res[0]);
      } else {
        _showScanResultDialog("No disease detected. You are healthy!");
      }
    } catch (e) {
      log('Error taking picture: $e');
    }
  }

  void _showScanResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Scan Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
    _controller!.setFlashMode(newFlashMode);
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 9.0 / 16.0,
                      child: CameraPreview(_controller!),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'toggleFlash',
            onPressed: _toggleFlash,
            child: Icon(_isFlashOn ? Iconsax.flash_slash : Iconsax.flash_1),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: 'scanSkin',
            onPressed: _scanSkin,
            child: const Icon(Iconsax.camera),
          ),
        ],
      ),
    );
  }
}
