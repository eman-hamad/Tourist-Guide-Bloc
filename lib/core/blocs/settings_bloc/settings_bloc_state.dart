part of 'settings_bloc_bloc.dart';

@immutable
abstract class SettingsBlocState {}

class SettingsBlocInitial extends SettingsBlocState {}

// ignore: must_be_immutable
class SettingsBlocThemeDark extends SettingsBlocState {
  ThemeData darkTh = kDarkTheme;
}

// ignore: must_be_immutable
class SettingsBlocThemeLight extends SettingsBlocState {
  ThemeData lightTh = klightTheme;
}
