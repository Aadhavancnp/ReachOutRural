import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class UploadedPrescriptionScreen extends StatelessWidget {
  const UploadedPrescriptionScreen({super.key, required this.tempFilePath});
  final String tempFilePath;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left_2, size: 28),
              onPressed: () => {context.pop(), context.pop()},
            ),
            title: const Text('Uploaded Prescription',
                style: TextStyle(fontWeight: FontWeight.bold)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: kPrimaryColor.withOpacity(0.1),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelColor: kWhiteColor,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(
                          child: Text(
                        'Local',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: kWhiteColor),
                      )),
                      Tab(
                          child: Text(
                        "Cloud",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: kWhiteColor),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            _buildLocalTab(),
            _buildCloudTab(),
          ])),
    );
  }

  Widget _buildLocalTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSectionTitle('Today (1)'),
          _buildImageGridForLocal(1),
          _buildSectionTitle('Last Week (5)'),
          _buildImageGrid(5),
        ],
      ),
    );
  }

  Widget _buildCloudTab() {
    return const Center(
      child: Text(
        'Cloud Storage',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageGrid(int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(16),
      children: List.generate(count, (index) => _buildImageCard(index == 0)),
    );
  }

  Widget _buildImageGridForLocal(int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(16),
      children: List.generate(count, (index) => _buildImageCardForLocal(true)),
    );
  }

  Widget _buildImageCardForLocal(bool isSelected) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              child: Ink.image(
                image: FileImage(File(tempFilePath)),
                fit: BoxFit.cover,
                child: InkWell(
                  splashColor: kPrimaryColor.withOpacity(0.3),
                  hoverColor: kPrimaryColor.withOpacity(0.3),
                  focusColor: kPrimaryColor.withOpacity(0.3),
                  highlightColor: kPrimaryColor.withOpacity(0.3),
                  onTap: () {},
                  onLongPress: () {},
                ),
              ),
            ),
          ),
          if (isSelected)
            const Positioned(
              top: 5,
              left: 5,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 10,
                child: Icon(Icons.check, size: 15, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageCard(bool isSelected) {
    const List<String> images = [
      'assets/images/prescription-1.jpg',
      'assets/images/prescription-2.jpg',
      'assets/images/prescription-3.jpg',
      'assets/images/prescription-4.jpg',
    ];
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              child: Ink.image(
                image: AssetImage(
                  Random().nextBool()
                      ? images[Random().nextInt(images.length)]
                      : images[Random().nextInt(images.length)],
                ),
                fit: BoxFit.cover,
                child: InkWell(
                  splashColor: kPrimaryColor.withOpacity(0.3),
                  hoverColor: kPrimaryColor.withOpacity(0.3),
                  focusColor: kPrimaryColor.withOpacity(0.3),
                  highlightColor: kPrimaryColor.withOpacity(0.3),
                  onTap: () {},
                  onLongPress: () {},
                ),
              ),
            ),
          ),
          if (isSelected)
            const Positioned(
              top: 5,
              left: 5,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 10,
                child: Icon(Icons.check, size: 15, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
