import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/community.dart';
import '../../../repository/storage/storage_repository.dart';

class CommunityItem extends StatelessWidget {
  final Community community;

  const CommunityItem({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    void navigate() async {
      final doctors = await context.read<StorageRepository>().getDoctors();

      final nearbyDoctors = doctors
          .where((doctor) =>
              doctor.specialization?.toLowerCase() ==
              community.specialization.toLowerCase())
          .toList();
      final extra = {"community": community, "doctors": nearbyDoctors};
      if (!context.mounted) return;
      context.push("/specialized-community", extra: extra);
    }

    return Card(
      color: community.color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kWhiteColor,
                  radius: 24, // You can adjust the size
                  child: community.icon,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kWhiteColor),
                      ),
                      Text('${community.memberCount} members',
                          style: const TextStyle(color: kWhiteColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              community.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kWhiteColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: navigate,
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, // Change button color,
                  foregroundColor: kWhiteColor),
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
