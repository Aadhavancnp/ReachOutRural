import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/services/api/api_service.dart';
import 'package:reach_out_rural/services/api/dio_client.dart';

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     final File image = File(imagePath);

//     navigateBackWithResult(String res) => context.pop(res);

//     return BlocProvider(
//       create: (context) => ScannerBloc(
//         apiService: context.read<ApiService>(),
//       ),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Display the Picture')),
//         body: SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//             child: Image.file(image, fit: BoxFit.cover)),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: SizedBox(
//           width: 70,
//           height: 70,
//           child: BlocBuilder<ScannerBloc, ScannerState>(
//             builder: (context, state) {
//               return FloatingActionButton(
//                 heroTag: 'sendAnalysis',
//                 backgroundColor: kPrimaryColor,
//                 foregroundColor: kWhiteColor,
//                 onPressed: () async {
//                   final res = await context.read<ScannerBloc>().scanSkin(image);
//                   navigateBackWithResult(res);
//                 },
//                 child: const Icon(
//                   Iconsax.tick_square,
//                   size: 35,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final api = ApiService(
      DioClient(Dio()),
    );
    final File image = File(imagePath);

    void navigateBackWithResult(String res) {
      context.pop([res]);
    }

    void sendAnalysis() async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      final res = await api.predict(formData);
      if (res.data["error"] != null) {
        log('Error sending image: ${res.data["error"]}');
        return;
      }
      log('Analysis result: ${res.data["condition"]}');
      navigateBackWithResult(res.data["condition"]);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(image, fit: BoxFit.cover)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          heroTag: 'sendAnalysis',
          backgroundColor: kPrimaryColor,
          foregroundColor: kWhiteColor,
          onPressed: sendAnalysis,
          child: const Icon(
            Iconsax.tick_square,
            size: 35,
          ),
        ),
      ),
    );
  }
}
