import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class ToastHelper {
  final FToast _fToast = FToast();

  ToastHelper(BuildContext context) {
    _fToast.init(context);
  }

  void showToast(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kInfoColor,
        ),
        child: Text(
          message,
          style: const TextStyle(color: kWhiteColor),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showCustomToast(String message, Color color) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showSuccessToast(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kSuccessColor,
        ),
        child: Text(
          message,
          style: const TextStyle(color: kWhiteColor),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showErrorToast(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kErrorColor,
        ),
        child: Expanded(
          child: Text(
            message,
            style: const TextStyle(color: kWhiteColor),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showWarningToast(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kWarningColor,
        ),
        child: Text(
          message,
          style: const TextStyle(color: kWhiteColor),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showSuccessCustomToastWithIcon(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kSuccessColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.tick_square,
              color: kWhiteColor,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kWhiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showErrorCustomToastWithIcon(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kErrorColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.close_square,
              color: kWhiteColor,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: kWhiteColor),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void showWarningCustomToastWithIcon(String message) {
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kWarningColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.warning_2,
              color: kWhiteColor,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              message,
              style: const TextStyle(color: kWhiteColor),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void cancelAllCustomToast() {
    _fToast.removeCustomToast();
  }

  void removeQueuedCustomToasts() {
    _fToast.removeQueuedCustomToasts();
  }
}
