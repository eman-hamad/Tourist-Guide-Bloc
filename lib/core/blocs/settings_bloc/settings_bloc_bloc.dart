import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../themes/dark_theme.dart';
import '../../themes/light_theme.dart';

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
