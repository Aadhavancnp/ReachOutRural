import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/age/cubit/age_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgeSelection extends StatelessWidget {
  const AgeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgeCubit, int>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.what_is_age,
                style: TextStyle(
                    fontSize: SizeConfig.getProportionateTextSize(25),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
                child: SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 50,
                looping: true,
                onSelectedItemChanged: (index) =>
                    context.read<AgeCubit>().selectAge(index),
                children: _generateAge(state),
              ),
            )),
            const SizedBox(height: 10),
            DefaultIconButton(
                width: SizeConfig.getProportionateScreenWidth(320),
                height: SizeConfig.getProportionateScreenHeight(60),
                fontSize: SizeConfig.getProportionateTextSize(20),
                text: AppLocalizations.of(context)!.continue_text,
                icon: Iconsax.arrow_right_35,
                press: () {
                  context.read<AgeCubit>().setUserPatientAge(state);
                  context.go('/height');
                }),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  List<Widget> _generateAge(int selectedAge) {
    final List<Widget> ageList = [];
    for (int i = 10; i <= 100; i++) {
      ageList.add(Center(
        child: Text(
          '$i',
          style: TextStyle(
            fontSize: 32,
            color: i == selectedAge ? kPrimaryColor : kGreyColor,
          ),
        ),
      ));
    }
    return ageList;
  }
}
