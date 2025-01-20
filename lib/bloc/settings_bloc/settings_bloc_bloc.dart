import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBlocBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBlocBloc() : super(SettingsBlocInitial());

  @override
  Stream<SettingsBlocState> mapEventToState(
    SettingsBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
