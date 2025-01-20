import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.profile_add, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Iconsax.more_square, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        // Use a Stack to overlay elements
        children: [
          // Background/Video Placeholder (if applicable)
          Center(
            child: Container(
                // Add a dummy avatar for the person.
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white),
                    color: Colors.redAccent),
                child: const Center(
                  child: Text('JD',
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                )),
          ),
          // Control Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CallControlButton(
                    icon: Iconsax.video,
                    onPressed: () {},
                  ),
                  CallControlButton(
                    icon: Iconsax.screenmirroring,
                    onPressed: () {},
                  ),
                  CallControlButton(
                    icon: Iconsax.microphone,
                    onPressed: () {},
                  ),
                  CallControlButton(
                    icon: Iconsax.call_slash,
                    onPressed: () {},
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          // Invite Message
        ],
      ),
    );
  }
}

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const CallControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey[800], //Default color
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
