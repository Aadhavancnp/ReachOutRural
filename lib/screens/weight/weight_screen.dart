import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/weight/cubit/weight_cubit.dart';
import 'package:reach_out_rural/screens/weight/weight_selection.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BlocProvider(
              create: (context) => WeightCubit(
                userPatientRepository: context.read<UserPatientRepository>(),
              ),
              child: WeightSelection(),
            )),
      ),
    );
  }
}
