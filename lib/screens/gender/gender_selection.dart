import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/screens/gender/cubit/gender_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<GenderCubit, Gender>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(localizations.what_is_gender,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(25),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                      context,
                      state,
                      Gender.male,
                      localizations.male,
                      "assets/animations/male.json",
                      Iconsax.man,
                      () => context
                          .read<GenderCubit>()
                          .selectGender(Gender.male)),
                  const SizedBox(width: 10),
                  _buildCard(
                      context,
                      state,
                      Gender.female,
                      localizations.female,
                      "assets/animations/female.json",
                      Iconsax.woman,
                      () => context
                          .read<GenderCubit>()
                          .selectGender(Gender.female)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            DefaultIconButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: AppLocalizations.of(context)!.continue_text,
                icon: Iconsax.arrow_right_35,
                press: () {
                  context.read<GenderCubit>().setUserPatientGender(state);
                  context.go('/age');
                }),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, Gender? currentState, Gender gender,
      String title, String assetPath, IconData icon, VoidCallback onTap) {
    final isSelected = currentState == gender;
    return Card(
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: kPrimaryColor, width: 5),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: kPrimaryColor,
      elevation: 5,
      child: SizedBox(
        height: SizeConfig.getProportionateScreenHeight(220),
        width: SizeConfig.getProportionateScreenWidth(160),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: SizeConfig.getProportionateScreenHeight(150),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: kWhiteColor,
                ),
                child: Center(
                    child: Lottie.asset(assetPath,
                        height: SizeConfig.getProportionateScreenHeight(180),
                        width: SizeConfig.getProportionateScreenWidth(180))),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateTextSize(15),
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    icon,
                    size: 30,
                    color: kWhiteColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
