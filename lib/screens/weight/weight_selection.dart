import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/screens/weight/cubit/weight_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class WeightSelection extends StatelessWidget {
  WeightSelection({super.key});

  final controller =
      WeightSliderController(initialWeight: 40.0, minWeight: 0, interval: 0.1);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightCubit, double>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.what_is_weight,
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(25),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(
                "${state.toStringAsFixed(1)} kg",
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(55),
                    fontWeight: FontWeight.w500),
              ),
            ),
            VerticalWeightSlider(
              unit: MeasurementUnit.kg,
              haptic: Haptic.lightImpact,
              controller: controller,
              decoration: const PointerDecoration(
                width: 130,
                height: 3,
                largeColor: Color(0xFF898989),
                mediumColor: Color(0xFFC5C5C5),
                smallColor: Color(0xFFF0F0F0),
                gap: 30,
              ),
              onChanged: (double value) =>
                  context.read<WeightCubit>().selectWeight(value),
              indicator: Container(
                height: 3,
                width: 200,
                alignment: Alignment.centerLeft,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 20),
            DefaultIconButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: AppLocalizations.of(context)!.continue_text,
                icon: Iconsax.arrow_right_35,
                press: () {
                  context.read<WeightCubit>().setUserPatientWeight(state);
                  context.go('/bloodgroup');
                }),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
