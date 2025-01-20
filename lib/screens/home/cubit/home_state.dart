part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.currentIndex = 0,
    this.isListening = false,
    this.recognizedText = '',
    this.currentPosition,
    this.locale,
    this.nextPath,
    this.permissionEvent,
  });

  final int currentIndex;
  final bool isListening;
  final String recognizedText;
  final Position? currentPosition;
  final Locale? locale;
  final String? nextPath;
  final PermissionEvent? permissionEvent;

  HomeState copyWith({
    int? currentIndex,
    bool? isListening,
    String? recognizedText,
    Position? currentPosition,
    Locale? locale,
    String? nextPath,
    PermissionEvent? permissionEvent,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      currentPosition: currentPosition ?? this.currentPosition,
      locale: locale ?? this.locale,
      nextPath: nextPath ?? this.nextPath,
      permissionEvent: permissionEvent ?? this.permissionEvent,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        isListening,
        recognizedText,
        currentPosition,
        locale,
        nextPath,
      ];
}


abstract class PermissionEvent {}

class ShowPermissionDeniedDialog extends PermissionEvent {
  final String permissionName;
  final Permission permissionType;

  ShowPermissionDeniedDialog(this.permissionName, this.permissionType);
}
class ShowLocationServiceDisabledDialog extends PermissionEvent {}
class ShowLocationPermissionDeniedDialog extends PermissionEvent {}
class ShowLocationPermissionPermanentlyDeniedDialog extends PermissionEvent {}
class ShowLocationErrorDialog extends PermissionEvent {
  final String error;
  ShowLocationErrorDialog(this.error);
}