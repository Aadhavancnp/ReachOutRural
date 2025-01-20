import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/register/bloc/register_bloc.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:reach_out_rural/widgets/default_button_loader.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final toaster = ToastHelper(context);

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        toaster.cancelAllCustomToast();
        if (state.status.isFailure && state.errorMsg.isNotEmpty) {
          toaster.showErrorCustomToastWithIcon(state.errorMsg);
        }
        if (state.status.isSuccess) {
          toaster.showSuccessCustomToastWithIcon(
              AppLocalizations.of(context)!.register_success);
          context.go('/otp/${state.phone.value}', extra: {
            'isLogin': false,
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
            AppLocalizations.of(context)!.register,
            style: TextStyle(
                fontSize: SizeConfig.getProportionateTextSize(32),
                fontVariations: const [FontVariation.weight(800)]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.register_desc,
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
          _RegisterButton(),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.have_account),
              TextButton(
                child: Text(AppLocalizations.of(context)!.login,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontVariations: [FontVariation.weight(700)])),
                onPressed: () {
                  context.go('/login');
                },
              ),
            ],
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
      (RegisterBloc bloc) => bloc.state.phone.displayError,
    );
    return IntlPhoneField(
      key: const Key('registerForm_phoneInput_textField'),
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
          context.read<RegisterBloc>().add(RegisterPhoneChanged(value.number)),
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

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (RegisterBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );
    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);

    return DefaultButtonLoader(
      isLoading: isInProgressOrSuccess,
      height: SizeConfig.getProportionateScreenHeight(56),
      width: SizeConfig.getProportionateScreenWidth(400),
      text: AppLocalizations.of(context)!.register,
      press: isValid
          ? () => context.read<RegisterBloc>().add(const RegisterSubmitted())
          : () {},
      fontSize: SizeConfig.getProportionateTextSize(20),
    );
  }
}
