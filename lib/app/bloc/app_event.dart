part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends AppEvent {
  const LanguageChanged({
    required this.locale,
  });
  final Locale locale;

  @override
  List<Object> get props => [locale];
}
