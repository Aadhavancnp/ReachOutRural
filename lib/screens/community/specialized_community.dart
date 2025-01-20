import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/models/community.dart';
import 'package:reach_out_rural/models/doctor.dart';

class SpecializedCommunity extends StatelessWidget {
  const SpecializedCommunity(
      {super.key, required this.community, required this.doctors});
  final Community community;
  final List<Doctor> doctors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(community.name),
        backgroundColor: community.color,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (_, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/default-doctor.png'),
              backgroundColor: Colors.white,
            ),
            title: Text(doctor.name),
            subtitle: Text(doctor.specialization ?? 'General'),
            trailing: ElevatedButton(
              onPressed: () {
                // Implement your "Book Appointment" action here
                context.push("/appointments");
              },
              child: const Text('Book Appointment'),
            ),
          );
        },
      ),
    );
  }
}
