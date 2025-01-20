import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/auth/auth_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/login/bloc/login_bloc.dart';
import 'package:reach_out_rural/screens/login/login_form.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocProvider(
              create: (context) => LoginBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
                userPatientRepository: context.read<UserPatientRepository>(),
              ),
              child: const LoginForm(),
            ),
          ),
        ),
      ),
    ));
  }
}
