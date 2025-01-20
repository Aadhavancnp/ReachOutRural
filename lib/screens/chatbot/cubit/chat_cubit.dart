import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/home/cubit/home_cubit.dart';
import 'package:reach_out_rural/services/api/api_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final HomeCubit homeCubit;
  late StreamSubscription _chatQuerySubscription;
  final SpeechToText _speech = SpeechToText();
  final ApiService _api;
  final StorageRepository _storageRepository;
  final UserPatientRepository _userPatientRepository;

  ChatCubit(
      {required this.homeCubit,
      required ApiService api,
      required StorageRepository storageRepository,
      required UserPatientRepository userPatientRepository})
      : _api = api,
        _storageRepository = storageRepository,
        _userPatientRepository = userPatientRepository,
        super(const ChatState()) {
    _chatQuerySubscription =
        homeCubit.chatCubitStreamController.stream.listen((query) {
      receiveQuery(query);
    });
  }

  @override
  void emit(ChatState state) {
    if (isClosed) return;

    super.emit(state);
  }

  Locale? _locale;

  void init() async {
    final localeString = await _storageRepository.getLocale() ?? "en";
    _locale = getLocaleFromCode(localeString);
    await initSpeech();
    await sendMessage(demoChatMessages[0].text);
  }

  void receiveQuery(String query) {
    emit(state.copyWith(currentQuery: query));
  }

  Future<void> initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      emit(state.copyWith(isRecording: false));
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    final chatMessage = ChatMessage(
      text: message,
      isSender: true,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );

    emit(state.copyWith(
      chatMessages: List.from(state.chatMessages)..add(chatMessage),
    ));

    final user = await _userPatientRepository.getUserPatient();

    Map<String, dynamic> data = {
      "text": message,
      "lang": _locale?.languageCode,
      "phone_number": user?.phone,
    };

    final res = await _api.chatbot(data);
    final textResponse = res.data['text_response'];

    final botMessage = ChatMessage(
      text: textResponse,
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );

    emit(state.copyWith(
      chatMessages: List.from(state.chatMessages)..add(botMessage),
    ));

    // Handle nearby doctors response
    final nearbyDoctors = res.data['doctors'] as List<dynamic>?;
    if (nearbyDoctors != null && nearbyDoctors.isNotEmpty) {
      final doctorsMessage = _formatDoctorsMessage(nearbyDoctors);
      emit(state.copyWith(
        chatMessages: List.from(state.chatMessages)..add(doctorsMessage),
      ));
    }
  }

  ChatMessage _formatDoctorsMessage(List<dynamic> doctorsData) {
    final doctors = doctorsData
        .map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
        .toList();
    String message = "Here are some nearby doctors\n\n";
    for (int i = 0; i < doctors.length; i++) {
      final doctor = doctors[i];
      message += "${i + 1}) ${doctor.name} - ${doctor.specialization}\n"
          "+${doctor.phone}\n"
          "Experience: ${doctor.experienceYears} years\n"
          "${doctor.location}\n\n";
    }
    return ChatMessage(
      text: message.trimRight(),
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
  }

  Future<void> recordAudio() async {
    bool available = await _speech.initialize();
    if (available) {
      emit(state.copyWith(isRecording: true));
      await _speech.listen(
        onResult: (result) {
          emit(state.copyWith(recognizedText: result.recognizedWords));
        },
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 10),
        listenOptions: SpeechListenOptions(
          enableHapticFeedback: true,
        ),
        localeId: _locale?.languageCode,
      );
    }
  }

  void stopListening() async {
    await _speech.stop();
    emit(state.copyWith(isRecording: false));
  }

  void sendAudio() async {
    final message = state.recognizedText;
    final chatMessage = ChatMessage(
      text: message,
      isSender: true,
      messageType: ChatMessageType.audio,
      messageStatus: MessageStatus.viewed,
    );

    emit(state.copyWith(
      chatMessages: List.from(state.chatMessages)..add(chatMessage),
      recognizedText: "",
    ));

    final user = await _userPatientRepository.getUserPatient();

    Map<String, dynamic> data = {
      "text": message,
      "lang": _locale?.languageCode,
      "phone_number": user?.phone,
    };

    final res = await _api.chatbot(data);
    final textResponse = res.data['text_response'];

    final botMessage = ChatMessage(
      text: textResponse,
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );

    emit(state.copyWith(
      chatMessages: List.from(state.chatMessages)..add(botMessage),
    ));

    // Handle nearby doctors response
    final nearbyDoctors = res.data['doctors'] as List<dynamic>?;
    if (nearbyDoctors != null && nearbyDoctors.isNotEmpty) {
      final doctorsMessage = _formatDoctorsMessage(nearbyDoctors);
      emit(state.copyWith(
        chatMessages: List.from(state.chatMessages)..add(doctorsMessage),
      ));
    }

    // Process audio message similarly to text message
  }

  void addAttachment(File file, ChatMessageType type) {
    final chatMessage = ChatMessage(
      text: file.path.split('/').last,
      isSender: true,
      messageType: type,
      messageStatus: MessageStatus.viewed,
      attachment: file.path,
    );

    emit(state.copyWith(
      chatMessages: List.from(state.chatMessages)..add(chatMessage),
    ));
  }

  @override
  Future<void> close() {
    _speech.cancel();
    _chatQuerySubscription.cancel();
    return super.close();
  }
}
