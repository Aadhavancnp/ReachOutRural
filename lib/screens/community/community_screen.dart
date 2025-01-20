import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/community.dart';
import 'package:reach_out_rural/screens/community/community_list.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Community'),
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          CommunityList(
            communities: communities,
          ),
        ],
      ),
    );
  }
}
