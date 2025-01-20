import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/diagnosis/cubit/diagnosis_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (context) => DiagnosisCubit(
          userPatientRepository: context.read<UserPatientRepository>()),
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateTextSize(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<DiagnosisCubit, DiagnosisState>(
                    builder: (context, state) {
                      return Text(
                        state.text.isNotEmpty
                            ? state.text
                            : AppLocalizations.of(context)!.diagnosis_desc,
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateTextSize(20),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<DiagnosisCubit, DiagnosisState>(
                    builder: (context, state) {
                      return DefaultIconButton(
                          width: SizeConfig.getProportionateScreenWidth(320),
                          height: SizeConfig.getProportionateScreenHeight(60),
                          fontSize: SizeConfig.getProportionateTextSize(20),
                          text: AppLocalizations.of(context)!.continue_text,
                          icon: Iconsax.arrow_right_35,
                          press: () {
                            context
                                .read<DiagnosisCubit>()
                                .setUserPatientDiagnosis();
                            context.replace('/');
                          });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<DiagnosisCubit, DiagnosisState>(
          builder: (context, state) {
            return AvatarGlow(
              animate: state.isListening,
              glowColor: kPrimaryColor,
              duration: const Duration(milliseconds: 1000),
              repeat: true,
              child: SizedBox(
                width: SizeConfig.getProportionateScreenWidth(70),
                height: SizeConfig.getProportionateScreenHeight(75),
                child: FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () => context.read<DiagnosisCubit>().listen(),
                  child: Center(
                    child: Icon(
                      state.isListening ? Iconsax.sound : Iconsax.microphone_2,
                      color: kWhiteColor,
                      size: 45,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
