import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/edit-profile/cubit/editprofile_cubit.dart';
import 'package:reach_out_rural/screens/edit-profile/edit_profile_view.dart';
import '../../services/api/api_service.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditprofileCubit(
        userPatientRepository: context.read<UserPatientRepository>(),
        apiService: context.read<ApiService>(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: const EditProfileView(),
    );
  }
}
