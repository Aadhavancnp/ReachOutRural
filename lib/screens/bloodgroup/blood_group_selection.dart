import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/bloodgroup/cubit/bloodgroup_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_button_loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BloodGroupSelection extends StatelessWidget {
  const BloodGroupSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return BlocBuilder<BloodgroupCubit, int>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.what_is_blood_group,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.getProportionateTextSize(25),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (int index) =>
                    context.read<BloodgroupCubit>().selectPage(index),
                itemCount: bloodGroupAssets.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => context
                          .read<BloodgroupCubit>()
                          .selectPage(index),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: index == state
                              ? kPrimaryColor.withOpacity(0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: index == state
                                  ? kPrimaryColor
                                  : Colors.transparent,
                              width: 5),
                        ),
                        child: SvgPicture.asset(
                          bloodGroupAssets[index],
                          height: SizeConfig.getProportionateScreenHeight(100),
                          width: SizeConfig.getProportionateScreenWidth(100),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: bloodGroupAssets.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey[300]!,
                  activeDotColor: kPrimaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 40),
            DefaultButtonLoader(
              isLoading: false,
              width: SizeConfig.getProportionateScreenWidth(320),
              height: SizeConfig.getProportionateScreenHeight(60),
              fontSize: SizeConfig.getProportionateTextSize(20),
              text: AppLocalizations.of(context)!.continue_text,
              press: () {
                context.read<BloodgroupCubit>().setUserPatientBloodgroup(state);
                context.go('/diagnosis');
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
