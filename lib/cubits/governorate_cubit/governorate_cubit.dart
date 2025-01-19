import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'governorate_state.dart';

class GovernorateCubit extends Cubit<GovernorateState> {
  GovernorateCubit() : super(GovernorateInitial());

  
}
