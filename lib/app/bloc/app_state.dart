part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    required this.locale,
  });
  final Locale locale;

  @override
  List<Object> get props => [locale];

  AppState copyWith({
    Locale? locale,
  }) {
    return AppState(
      locale: locale ?? this.locale,
    );
  }
}
