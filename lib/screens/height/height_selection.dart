import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/height/cubit/height_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeightSelection extends StatelessWidget {
  HeightSelection({super.key});

  final RulerPickerController _rulerPickerController =
      RulerPickerController(value: 40.0);

  final List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 10, scale: 0.1),
    RulerRange(begin: 10, end: 100, scale: 0.5),
    RulerRange(begin: 100, end: 1000, scale: 0.10),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeightCubit, num>(
      builder: (context, state) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.what_is_height,
              style: TextStyle(
                  fontSize: SizeConfig.getProportionateTextSize(25),
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            "${state.toStringAsFixed(1)} cm",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.getProportionateTextSize(60)),
          ),
          const SizedBox(height: 30),
          RulerPicker(
            controller: _rulerPickerController,
            onBuildRulerScaleText: (index, value) => value.toInt().toString(),
            ranges: ranges,
            rulerScaleTextStyle: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            scaleLineStyleList: const [
              ScaleLineStyle(
                  color: Colors.grey, width: 1.5, height: 30, scale: 0),
              ScaleLineStyle(
                  color: Colors.grey, width: 1, height: 25, scale: 5),
              ScaleLineStyle(
                  color: Colors.grey, width: 1, height: 15, scale: -1)
            ],
            onValueChanged: (value) =>
                context.read<HeightCubit>().selectHeight(value),
            width: SizeConfig.screenWidth,
            height: 100,
            rulerMarginTop: 35,
            marker: Container(
                width: 8,
                height: SizeConfig.getProportionateScreenHeight(110),
                decoration: BoxDecoration(
                    color: kPrimaryColor.withAlpha(130),
                    borderRadius: BorderRadius.circular(5))),
          ),
          const SizedBox(height: 30),
          DefaultIconButton(
              width: SizeConfig.getProportionateScreenWidth(320),
              height: SizeConfig.getProportionateScreenHeight(60),
              fontSize: SizeConfig.getProportionateTextSize(20),
              text: AppLocalizations.of(context)!.continue_text,
              icon: Iconsax.arrow_right_35,
              press: () {
                context.read<HeightCubit>().setUserPatientHeight(state);
                context.go('/weight');
              }),
          const SizedBox(height: 20),
        ]);
      },
    );
  }
}
