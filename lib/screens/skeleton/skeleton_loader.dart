import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer(gradient: shimmerGradient, child: child ?? const SizedBox());
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar shimmer
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(height: 16),
              // Two cards shimmer
              Row(
                children: [
                  Expanded(child: _buildCardShimmer()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCardShimmer()),
                ],
              ),
              const SizedBox(height: 16),
              // Nearby hospitals shimmer
              _buildSectionTitleShimmer(),
              const SizedBox(height: 10),
              SizedBox(
                height: 213,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildHospitalCardShimmer(),
                ),
              ),
              const SizedBox(height: 10),
              _buildButtonShimmer(),
              const SizedBox(height: 16),
              // Nearby doctors shimmer
              _buildSectionTitleShimmer(),
              const SizedBox(height: 10),
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => _buildDoctorListTileShimmer(),
              ),
              const SizedBox(height: 10),
              _buildButtonShimmer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardShimmer() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildSectionTitleShimmer() {
    return Container(
      width: 150,
      height: 20,
      color: Colors.white,
    );
  }

  Widget _buildHospitalCardShimmer() {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildButtonShimmer() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildDoctorListTileShimmer() {
    return ListTile(
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
      ),
      title: Container(
        width: double.infinity,
        height: 16,
        color: Colors.white,
      ),
      subtitle: Container(
        width: double.infinity,
        height: 14,
        color: Colors.white,
      ),
      trailing: Container(
        width: 20,
        height: 20,
        color: Colors.white,
      ),
    );
  }
}
