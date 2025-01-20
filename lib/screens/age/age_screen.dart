import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/age/age_selection.dart';
import 'package:reach_out_rural/screens/age/cubit/age_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BlocProvider(
                create: (context) => AgeCubit(
                    userPatientRepository:
                        context.read<UserPatientRepository>()),
                child: const AgeSelection(),
              ))),
    );
  }
}
