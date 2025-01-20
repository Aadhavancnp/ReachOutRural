import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/widgets/custom_bottom_navbar_item.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar(
      {super.key,
      required this.currentIndex,
      required this.onPressed,
      required this.onCaptureVoice,
      required this.isListening});
  final int currentIndex;
  final bool isListening;
  final VoidCallback onCaptureVoice;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: 54,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
          color: kWhiteColor.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: kBlackColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 0))
          ]),
      child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CustomBottomNavItem(
                  icon: Iconsax.home,
                  onPressed: onPressed,
                  currentIndex: currentIndex,
                  index: 0),
              CustomBottomNavItem(
                  icon: Iconsax.message_text,
                  onPressed: onPressed,
                  currentIndex: currentIndex,
                  index: 1),
              const SizedBox(width: 20),
              CustomBottomNavItem(
                  icon: Iconsax.camera,
                  onPressed: onPressed,
                  currentIndex: currentIndex,
                  index: 2),
              CustomBottomNavItem(
                  icon: Iconsax.people,
                  onPressed: onPressed,
                  currentIndex: currentIndex,
                  index: 3),
            ]),
            Positioned(
              top: -45,
              child: AvatarGlow(
                animate: isListening,
                glowColor: kPrimaryColor,
                duration: const Duration(milliseconds: 1000),
                child: IconButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(kPrimaryColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15))),
                    onPressed: () => onCaptureVoice(),
                    icon: Icon(
                      isListening ? Iconsax.sound : Iconsax.microphone_2,
                      color: kWhiteColor,
                    ),
                    iconSize: 35),
              ),
            )
          ]),
    ));
  }
}
