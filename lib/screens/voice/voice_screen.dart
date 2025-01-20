import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Iconsax.arrow_left_2,
                              color: Colors.white)),
                      const SizedBox(width: 8),
                      const Text('Voice Call',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.profile_add,
                              color: Colors.white)),
                      const SizedBox(width: 10),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.more_square,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.red,
                      child: Text('JD',
                          style: TextStyle(fontSize: 40, color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    const Text('John Doe',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('00:03:24',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 16)),
                  ],
                ),
              ),
              // Invite button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: kWhiteColor,
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('Invite people to join you!'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Bottom controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircleIconButton(Iconsax.video, Colors.grey[800]!),
                  _buildCircleIconButton(
                      Iconsax.screenmirroring, Colors.grey[800]!),
                  _buildCircleIconButton(Iconsax.microphone, Colors.grey[800]!),
                  _buildCircleIconButton(Iconsax.call_slash, Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: SizedBox(
        width: 60,
        height: 60,
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}
