part of 'settings_bloc_bloc.dart';

@immutable
abstract class SettingsBlocState {}

class SettingsBlocInitial extends SettingsBlocState {}

class SettingsBlocThemeDark extends SettingsBlocState {
  ThemeData darkTh = kDarkTheme;
}

class SettingsBlocThemeLight extends SettingsBlocState {
  ThemeData lightTh = klightTheme;
}
