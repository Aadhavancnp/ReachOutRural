import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/bloodgroup/blood_group_selection.dart';
import 'package:reach_out_rural/screens/bloodgroup/cubit/bloodgroup_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class BloodGroupScreen extends StatefulWidget {
  const BloodGroupScreen({super.key});

  @override
  State<BloodGroupScreen> createState() => _BloodGroupScreenState();
}

class _BloodGroupScreenState extends State<BloodGroupScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BlocProvider(
              create: (context) => BloodgroupCubit(
                  userPatientRepository: context.read<UserPatientRepository>()),
              child: const BloodGroupSelection(),
            )),
      ),
    );
  }
}
