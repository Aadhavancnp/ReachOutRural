import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/screens/splash/cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        storageRepository: context.read<StorageRepository>(),
      )..checkSplashSeen(),
      child: BlocListener<SplashCubit, bool>(
        listener: (context, hasSeenSplash) {
          if (hasSeenSplash) {
            context.go('/onboarding');
          }
        },
        child: const Scaffold(
          body: Center(child: AnimatedTextBuilder()),
        ),
      ),
    );
  }
}

class AnimatedTextBuilder extends StatelessWidget {
  const AnimatedTextBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        CustomTypewriterAnimatedText(
          'ReachOutRural',
          textStyle:
              const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          speed: const Duration(milliseconds: 200),
        ),
      ],
      onFinished: () {
        context.read<SplashCubit>().markSplashAsSeen();
      },
      totalRepeatCount: 1,
      isRepeatingAnimation: false,
    );
  }
}

class CustomTypewriterAnimatedText extends AnimatedText {
  final Duration speed;

  CustomTypewriterAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 200),
  }) : super(
          text: text,
          duration: speed * text.characters.length,
        );

  late Animation<double> _typewriterText;

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final numberOfCharacters =
        (_typewriterText.value * text.characters.length).round();
    // final displayedText = text.substring(0, numberOfCharacters);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Reach',
            style: textStyle?.copyWith(color: Colors.blue),
          ),
          TextSpan(
            text: 'Out',
            style: textStyle?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          TextSpan(
            text: 'Rural',
            style: textStyle?.copyWith(color: Colors.blue),
          ),
        ].map((span) {
          final startIndex = text.indexOf(span.text!);
          final endIndex = startIndex + span.text!.length;
          if (numberOfCharacters <= startIndex) {
            return const TextSpan(text: '');
          } else if (numberOfCharacters < endIndex) {
            return TextSpan(
              text: span.text!.substring(0, numberOfCharacters - startIndex),
              style: span.style,
            );
          } else {
            return span;
          }
        }).toList(),
      ),
    );
  }
}
