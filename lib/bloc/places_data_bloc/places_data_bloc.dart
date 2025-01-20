import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'places_data_event.dart';
part 'places_data_state.dart';

class PlacesDataBloc extends Bloc<PlacesDataEvent, PlacesDataState> {
  PlacesDataBloc() : super(PlacesDataInitial());

  @override
  Stream<PlacesDataState> mapEventToState(
    PlacesDataEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
