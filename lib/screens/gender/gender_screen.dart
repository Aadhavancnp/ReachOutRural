import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/gender/cubit/gender_cubit.dart';
import 'package:reach_out_rural/screens/gender/gender_selection.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
              width: double.infinity,
              child: BlocProvider(
                create: (context) => GenderCubit(
                    userPatientRepository:
                        context.read<UserPatientRepository>()),
                child: const GenderSelection(),
              )),
        ),
      ),
    );
  }
}
