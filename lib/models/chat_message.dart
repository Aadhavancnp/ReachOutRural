import 'package:equatable/equatable.dart';

enum ChatMessageType { text, audio, image, video, file }

enum MessageStatus { notSent, notView, viewed }

class ChatMessage extends Equatable {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final DateTime time = DateTime.now();
  final String? attachment;

  ChatMessage({
    this.text = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    this.attachment,
  });

  @override
  List<Object?> get props =>
      [text, messageType, messageStatus, isSender, time, attachment];
}

List demoChatMessages = [
  ChatMessage(
    text: "Hi there! How can I help you today?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Hello, I want to know more\nabout my health",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "Sure, I can help you with that.\nWhat do you want to know?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notView,
    isSender: false,
  ),
  ChatMessage(
    text: "How can I check my blood pressure?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "You can check your blood pressure\nusing this device",
    messageType: ChatMessageType.image,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Here is a video on how to use it",
    messageType: ChatMessageType.video,
    messageStatus: MessageStatus.notView,
    isSender: false,
  ),
  ChatMessage(
    text: "Glad you like it 🤗",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notView,
    isSender: false,
  ),
  ChatMessage(
    text: "I have a headache",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "You can take this medicine\nfor your headache",
    messageType: ChatMessageType.file,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "I will take it. Thank you!",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notView,
    isSender: true,
  ),
];
