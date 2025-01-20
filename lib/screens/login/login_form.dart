import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/login/bloc/login_bloc.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/widgets/default_button_loader.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final toaster = ToastHelper(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        toaster.cancelAllCustomToast();
        if (state.status.isFailure && state.errorMsg.isNotEmpty) {
          toaster.showErrorCustomToastWithIcon(state.errorMsg);
        }
        if (state.status.isSuccess) {
          toaster.showSuccessCustomToastWithIcon(
              AppLocalizations.of(context)!.login_success);
          context.go('/otp/${state.phone.value}', extra: {
            'isLogin': true,
          });
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 20),
          SvgPicture.asset(
            "assets/icons/logo.svg",
            height: SizeConfig.getProportionateScreenHeight(125),
            width: SizeConfig.getProportionateScreenWidth(125),
          ),
          const SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.login,
            style: TextStyle(
                fontSize: SizeConfig.getProportionateTextSize(32),
                fontVariations: const [FontVariation.weight(800)]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.login_desc,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.getProportionateScreenHeight(35),
            child: Text(
              AppLocalizations.of(context)!.phone_number,
              style: TextStyle(
                fontSize: SizeConfig.getProportionateTextSize(16),
                fontVariations: const [FontVariation.weight(700)],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const _PhoneNumberInput(),
          const SizedBox(height: 35),
          _LoginButton(),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.dont_have_account),
              TextButton(
                child: Text(AppLocalizations.of(context)!.register,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontVariations: [FontVariation.weight(700)])),
                onPressed: () {
                  context.go('/register');
                },
              ),
            ],
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.need_help,
                style: const TextStyle(color: kPrimaryColor)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  const _PhoneNumberInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.phone.displayError,
    );
    return IntlPhoneField(
      key: const Key('loginForm_phoneNumberInput_textField'),
      decoration: InputDecoration(
        counterText: "",
        labelText: AppLocalizations.of(context)!.phone_number,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        errorText: displayError != null
            ? AppLocalizations.of(context)!.invalid_phone_number
            : null,
      ),
      onChanged: (value) =>
          context.read<LoginBloc>().add(PhoneChanged(value.number)),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      dropdownTextStyle: const TextStyle(
        fontVariations: [FontVariation.weight(700)],
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      initialCountryCode: 'IN',
      style: TextStyle(
        fontSize: SizeConfig.getProportionateTextSize(20),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);

    return DefaultButtonLoader(
      isLoading: isInProgressOrSuccess,
      height: SizeConfig.getProportionateScreenHeight(56),
      width: SizeConfig.getProportionateScreenWidth(400),
      text: AppLocalizations.of(context)!.login,
      press: isValid
          ? () => context.read<LoginBloc>().add(const LoginSubmitted())
          : () {},
      fontSize: SizeConfig.getProportionateTextSize(20),
    );
  }
}
