import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/profile/cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.userPatient);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () => context.push('/edit-profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit(
          userPatientRepository: context.read<UserPatientRepository>(),
        ),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.read<ProfileCubit>().pickImage(),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: state.avatarPath != null
                            ? FileImage(File(state.avatarPath!))
                            : null,
                        child: state.avatarPath == null
                            ? Icon(Iconsax.camera,
                                size: 50, color: Colors.grey[700])
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.name.isNotEmpty ? user.name : 'Name not set',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(user.email.isNotEmpty ? user.email : 'Email not set'),
                    const SizedBox(height: 10),
                    Text(user.phone.isNotEmpty ? user.phone : 'Phone not set'),
                    const SizedBox(height: 10),
                    Text('Age: ${user.age}'),
                    const SizedBox(height: 10),
                    Text(user.location.isNotEmpty
                        ? 'Location: ${user.location}'
                        : 'Location not set'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
