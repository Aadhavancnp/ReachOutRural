part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.chatMessages = const [],
    this.isRecording = false,
    this.recognizedText = "",
    this.currentQuery,
  });

  final String? currentQuery;
  final List<ChatMessage> chatMessages;
  final bool isRecording;
  final String recognizedText;

  ChatState copyWith(
      {List<ChatMessage>? chatMessages,
      bool? isRecording,
      String? recognizedText,
      String? currentQuery}) {
    return ChatState(
        chatMessages: chatMessages ?? this.chatMessages,
        isRecording: isRecording ?? this.isRecording,
        recognizedText: recognizedText ?? this.recognizedText,
        currentQuery: currentQuery ?? this.currentQuery);
  }

  @override
  List<Object?> get props =>
      [chatMessages, isRecording, recognizedText, currentQuery];
}
