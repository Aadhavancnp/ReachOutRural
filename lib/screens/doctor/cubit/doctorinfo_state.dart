part of 'doctorinfo_cubit.dart';

class DoctorinfoState extends Equatable {
  const DoctorinfoState({
    required this.isListening,
    required this.recognizedText,
    this.locale = const Locale('en', 'US'),
    this.shouldNavigateToAppointments = false,
  });

  final bool isListening;
  final String recognizedText;
  final Locale locale;
  final bool shouldNavigateToAppointments;

  DoctorinfoState copyWith({
    bool? isListening,
    String? recognizedText,
    Locale? locale,
    bool? shouldNavigateToAppointments,
  }) {
    return DoctorinfoState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      locale: locale ?? this.locale,
      shouldNavigateToAppointments:
          shouldNavigateToAppointments ?? this.shouldNavigateToAppointments,
    );
  }

  @override
  List<Object> get props => [isListening, recognizedText, locale, shouldNavigateToAppointments];
}


