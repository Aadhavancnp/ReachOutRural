import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_content.dart';
import 'package:reach_out_rural/screens/chatbot/cubit/chat_cubit.dart';
import 'package:reach_out_rural/screens/home/cubit/home_cubit.dart';
import '../../services/api/api_service.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/chatbot.svg",
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat Bot",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.call),
            onPressed: () {
              context.push('/voice');
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.video),
            onPressed: () {
              context.push('/video');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
          create: (context) => ChatCubit(
                homeCubit: context.read<HomeCubit>(),
                api: context.read<ApiService>(),
                storageRepository: context.read<StorageRepository>(),
                userPatientRepository: context.read<UserPatientRepository>(),
              )..init(),
          child: const ChatBotContent()),
    );
  }
}
