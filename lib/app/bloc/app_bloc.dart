import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required Locale locale,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        super(AppState(locale: locale)) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  final StorageRepository _storageRepository;

  void _onLanguageChanged(LanguageChanged event, Emitter<AppState> emit)async {
    await _storageRepository.saveLocale(event.locale.languageCode);
    emit(state.copyWith(
      locale: event.locale,
    ));
  }
}
