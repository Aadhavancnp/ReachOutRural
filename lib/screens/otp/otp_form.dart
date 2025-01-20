import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/widgets/default_button_loader.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 90,
      height: 90,
      textStyle: TextStyle(
        fontSize: SizeConfig.getProportionateTextSize(24),
        color: Theme.of(context).brightness == Brightness.dark
            ? kWhiteColor
            : kBlackColor,
      ),
      decoration: BoxDecoration(
        color: const Color(0x84DEE7F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    void onPress() {
      if (isLogin) {
        context.replace('/');
      } else {
        context.go('/gender');
      }
    }

    return Column(
      children: [
        SizedBox(height: SizeConfig.getProportionateScreenHeight(50)),
        Pinput(
          length: 6,
          defaultPinTheme: defaultPinTheme,
          keyboardType: TextInputType.number,
          closeKeyboardWhenCompleted: true,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: kPrimaryColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) => {},
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        SizedBox(height: SizeConfig.getProportionateScreenHeight(45)),
        DefaultButtonLoader(
          isLoading: false,
          text: AppLocalizations.of(context)!.continue_text,
          width: SizeConfig.getProportionateScreenWidth(350),
          height: SizeConfig.getProportionateScreenHeight(60),
          fontSize: SizeConfig.getProportionateTextSize(18),
          press: onPress,
        ),
      ],
    );
  }
}
