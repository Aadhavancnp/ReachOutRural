import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/screens/onboarding/onboarding_content.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/widgets/default_button_loader.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _onButtonPressed() async {
    if (_currentPage < onBoardingScreens.length - 1) {
      _pageController.nextPage(
        duration: kAnimationDuration,
        curve: Curves.ease,
      );
    } else {
      await context.read<StorageRepository>().setUserOnboarding(true);
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onBoardingScreens.length,
                  itemBuilder: (_, index) =>
                      OnboardingContent(currentPage: index),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(20)),
                  child: Column(
                    children: [
                      const Spacer(),
                      _buildDotIndicators(),
                      const Spacer(flex: 3),
                      _buildButton(),
                      const Spacer(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onBoardingScreens.length,
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? kPrimaryColor : kGreyDotColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildButton() {
    return DefaultButtonLoader(
      isLoading: false,
      width: SizeConfig.getProportionateScreenWidth(350),
      height: SizeConfig.getProportionateScreenHeight(56),
      fontSize: SizeConfig.getProportionateTextSize(18),
      text: _currentPage == onBoardingScreens.length - 1
          ? AppLocalizations.of(context)!.get_started
          : AppLocalizations.of(context)!.continue_text,
      press: _onButtonPressed,
    );
  }
}
