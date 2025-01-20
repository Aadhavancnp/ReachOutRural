part of 'diagnosis_cubit.dart';

class DiagnosisState extends Equatable {
  const DiagnosisState({
    this.isListening = false,
    this.text = '',
  });

  final bool isListening;
  final String text;

  @override
  List<Object> get props => [isListening, text];
}
