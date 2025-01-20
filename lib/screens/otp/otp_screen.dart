import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/otp/otp_form.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen(
      {super.key, required this.phoneNumber, required this.isLogin});
  final String phoneNumber;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.otp_verification),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.getProportionateTextSize(20)),
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(60)),
                    Text.rich(
                      TextSpan(
                        text:
                            AppLocalizations.of(context)!.otp_verification_desc,
                        children: [
                          TextSpan(
                            text: "+91$phoneNumber",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    buildTimer(context),
                    OtpForm(isLogin: isLogin),
                    SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(30)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.resend_otp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Row buildTimer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.otp_expire),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 00.0),
          duration: const Duration(seconds: 60),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
