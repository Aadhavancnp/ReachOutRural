import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/screens/chatbot/cubit/chat_cubit.dart';
import 'package:reach_out_rural/screens/chatbot/message.dart';
import 'package:reach_out_rural/screens/chatbot/messasge_attachment_modal.dart';

class ChatBotContent extends StatefulWidget {
  const ChatBotContent({super.key});

  @override
  State<ChatBotContent> createState() => _ChatBotContentState();
}

class _ChatBotContentState extends State<ChatBotContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  void _scrollToBottom() {
    if (!mounted) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.chatMessages.length,
                  itemBuilder: (context, index) =>
                      Message(message: state.chatMessages[index]),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildInputArea(context, state)
          ],
        );
      },
    );
  }

  Container _buildInputArea(BuildContext context, ChatState state) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return TextField(
                  focusNode: _messageFocusNode,
                  controller: _messageController,
                  style: const TextStyle(fontSize: 16, color: kBlackColor),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: const TextStyle(fontSize: 16, color: kGreyColor),
                    prefixIcon: _buildMicrophoneButton(context, state),
                    suffixIcon: IconButton(
                        onPressed: () => _showAttachmentModal(context),
                        splashColor: kPrimaryColor.withOpacity(0.3),
                        focusColor: kPrimaryColor.withOpacity(0.3),
                        hoverColor: kPrimaryColor.withOpacity(0.3),
                        highlightColor: kPrimaryColor.withOpacity(0.3),
                        icon:
                            const Icon(Iconsax.paperclip, color: kBlackColor)),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    labelStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey[50]!),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey[50]!),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(kPrimaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            onPressed: () {
              context.read<ChatCubit>().sendMessage(_messageController.text);
              _messageController.clear();
            },
            padding: const EdgeInsets.all(14),
            icon: const Icon(
              Iconsax.send_1,
              color: kWhiteColor,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  AvatarGlow _buildMicrophoneButton(BuildContext context, ChatState state) {
    return AvatarGlow(
      animate: state.isRecording,
      glowColor: kPrimaryColor,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 1000),
      repeat: true,
      child: GestureDetector(
        onLongPress: () => context.read<ChatCubit>().recordAudio(),
        onLongPressEnd: (details) {
          context.read<ChatCubit>().stopListening();
          _showAudioConfirmationDialog(context, () {
            context.read<ChatCubit>().sendAudio();
          });
        },
        child: IconButton(
            splashColor: kPrimaryColor.withOpacity(0.3),
            focusColor: kPrimaryColor.withOpacity(0.3),
            hoverColor: kPrimaryColor.withOpacity(0.3),
            highlightColor: kPrimaryColor.withOpacity(0.3),
            onPressed: () => _messageFocusNode.unfocus(),
            icon: const Icon(
              Iconsax.microphone_2,
              color: kWhiteColor,
            )),
      ),
    );
  }

  void _showAudioConfirmationDialog(BuildContext context, VoidCallback onSend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Audio Confirmation"),
        content: const Text("Are you sure you want to send this audio?"),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onSend();
            },
            child: const Text("Send"),
          )
        ],
      ),
    );
  }

  void _showAttachmentModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const MessageAttachmentModal(),
    );
    _messageFocusNode.unfocus();
    if (result == null) return;
    final file = result[0] as File;
    final type = result[1] as ChatMessageType;
    if (!context.mounted) return;
    context.read<ChatCubit>().addAttachment(file, type);
  }
}
