import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/screens/chatbot/audio_message.dart';
import 'package:reach_out_rural/screens/chatbot/document_message.dart';
import 'package:reach_out_rural/screens/chatbot/image_message.dart';
import 'package:reach_out_rural/screens/chatbot/message_status.dart';
import 'package:reach_out_rural/screens/chatbot/text_message.dart';
import 'package:reach_out_rural/screens/chatbot/video_message.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContainer(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return VideoMessage(video: message.attachment);
        case ChatMessageType.image:
          return ImageMessage(image: message.attachment);
        case ChatMessageType.file:
          return DocumentMessage(document: message.attachment);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 20,
              child: ClipOval(
                  child: SvgPicture.asset("assets/icons/chatbot.svg",
                      height: 30, width: 30, fit: BoxFit.cover)),
            ),
            const SizedBox(width: 8),
          ],
          messageContainer(message),
          if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}
