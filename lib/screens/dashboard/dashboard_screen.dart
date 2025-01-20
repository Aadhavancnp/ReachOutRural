import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:reach_out_rural/screens/skeleton/skeleton_loader.dart';
import '../../services/api/api_service.dart';
import '../../../repository/storage/storage_repository.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.userPatient);
    final asset = user.gender.name.toLowerCase() == "male"
        ? "assets/images/male.png"
        : "assets/images/female.png";
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(
                    Iconsax.location,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.location,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kWhiteColor,
                    backgroundImage: AssetImage(asset),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(color: kWhiteColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.profile,
              ),
              leading: const Icon(Iconsax.user),
              onTap: () {
                context.push("/profile");
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.prescriptions,
              ),
              leading: const Icon(Iconsax.document),
              onTap: () {
                context.push("/prescription");
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.logout,
              ),
              leading: const Icon(Iconsax.logout),
              onTap: () {
                context.read<AuthBloc>().add(AuthenticationLogoutPressed());
                context.replace('/login');
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => DashboardCubit(
          apiService: context.read<ApiService>(),
          storageRepository: context.read<StorageRepository>(),
          userPatientRepository: context.read<UserPatientRepository>(),
        )..loadDashboardData(),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const DashboardShimmer();
            } else if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async =>
                    await context.read<DashboardCubit>().loadDashboardData(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search input below the top app bar
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(14)),
                          child: TextField(
                            style: const TextStyle(color: kBlackColor),
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(color: kGreyColor),
                              hintText: AppLocalizations.of(context)!
                                  .search_for_doctor,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors
                                      .grey), // Search icon inside the input field
                            ),
                            onTap: () {
                              context.push("/search", extra: state.doctors);
                            },
                          ),
                        ),
                        const SizedBox(
                            height: 16), // Space between search bar and cards
                        // Row with two cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildCard(
                                AppLocalizations.of(context)!.book_appointment,
                                'assets/images/appointment_image.jpg', // Replace with your image asset path
                                context,
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Space between the two cards
                            Expanded(
                              child: _buildCard(
                                AppLocalizations.of(context)!
                                    .instant_vid_consultation,
                                'assets/images/video_consultation_image.jpg', // Replace with your image asset path
                                context,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .nearby_hospitals,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 225,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.hospitals.length,
                                      itemBuilder: (context, index) {
                                        return HospitalCard(
                                            hospital: state.hospitals[index]);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.push("/search-hospitals",
                                          extra: state.hospitals);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kWhiteColor,
                                    ),
                                    child: Text(AppLocalizations.of(context)!
                                        .view_more_hospitals),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              Text(
                                AppLocalizations.of(context)!.nearby_doctors,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Column(children: [
                                ListView.builder(
                                  itemCount: state.doctors.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) => ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hoverColor: kPrimaryColor.withOpacity(0.1),
                                    splashColor: kPrimaryColor.withOpacity(0.1),
                                    focusColor: kPrimaryColor.withOpacity(0.1),
                                    leading: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/default-doctor.png'),
                                      backgroundColor: Colors.white,
                                    ),
                                    title: Text(state.doctors[i].name),
                                    subtitle: Text(
                                        state.doctors[i].specialization ??
                                            'General'),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: () {
                                      // Navigate to doctor details or booking
                                      context.push("/doctor",
                                          extra: state.doctors[i]);
                                    },
                                  ),
                                )
                              ]),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context.push("/search-doctor",
                                      extra: state.doctors);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kWhiteColor,
                                ),
                                child: Text(AppLocalizations.of(context)!
                                    .view_more_doctors),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is DashboardError) {
              return Text('Error: ${state.message}');
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: ElevatedButton(
              onPressed: () {
                // Add navigation or action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.learn_more,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigate to hospital details or booking
          // context.push("/hospital", extra: hospital);
        },
        child: SizedBox(
          width: 185,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                    radius: 27,
                    child:
                        Icon(Iconsax.hospital, size: 27, color: Colors.blue)),
                const SizedBox(height: 8),
                Text(
                  hospital.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hospital.speciality == "Unknown"
                      ? "General"
                      : hospital.speciality,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 3),
                Text(
                  '${hospital.distance.toStringAsFixed(1)} km away',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
