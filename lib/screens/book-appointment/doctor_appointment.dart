import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomTopNavbar(
          title: 'Today Appointments', // Center text
          onProfile: () {
            // context.go('/profile'); // Navigate to profile page
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DoctorCard(
              name: 'Loki Bright',
              doctor: 'Kelly Williams',
              time: 'Today 10:30 am',
              imageUrl: 'assets/images/prescription-4.jpg',
              backgroundColor: Colors.lightBlue[100]!,
            ),
            DoctorCard(
              name: 'Lori Bryson',
              doctor: 'Katherine Moss',
              time: 'Today 11:30 am',
              imageUrl: 'assets/images/prescription-4.jpg',
              backgroundColor: Colors.amber[100]!,
            ),
            DoctorCard(
              name: 'Orlando Diggs',
              doctor: 'Kelly Williams',
              time: 'Today 12:30 pm',
              imageUrl: 'assets/images/prescription-4.jpg',
              backgroundColor: Colors.yellow[100]!,
            ),
          ],
        ));
  }
}

class CustomTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onProfile;

  const CustomTopNavbar({
    super.key,
    required this.title,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: onProfile,
        ),
      ],
      centerTitle: true,
      elevation: 0, // Remove shadow if needed
      // backgroundColor: Colors.white, // Adjust color as needed
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String doctor;
  final String time;
  final String imageUrl;
  final Color backgroundColor;

  const DoctorCard({
    super.key,
    required this.name,
    required this.doctor,
    required this.time,
    required this.imageUrl,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 16.0),
            // Doctor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kBlackColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Patients: $doctor',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Consult Button
            ElevatedButton(
              onPressed: () {
                // Consult Action
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Colors.black,
              ),
              child:
                  const Text('Consult', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
