import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/height/cubit/height_cubit.dart';
import 'package:reach_out_rural/screens/height/height_selection.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class HeightScreen extends StatelessWidget {
  const HeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BlocProvider(
              create: (context) => HeightCubit(
                userPatientRepository: context.read<UserPatientRepository>(),
              ),
              child: HeightSelection(),
            )),
      ),
    );
  }
}
