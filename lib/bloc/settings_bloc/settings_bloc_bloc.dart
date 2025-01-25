import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tourist_guide/core/themes/dark_theme.dart';
import 'package:tourist_guide/core/themes/light_theme.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBlocBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBlocBloc() : super(SettingsBlocThemeLight()) {
    on<ToggleTheme>((event, emit) {
      if (state is SettingsBlocThemeLight) {
        emit(SettingsBlocThemeDark());
      } else if (state is SettingsBlocThemeDark) {
        emit(SettingsBlocThemeLight());
      }
    });
  }
}
