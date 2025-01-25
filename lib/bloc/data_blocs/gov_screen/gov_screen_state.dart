part of 'gov_screen_cubit.dart';

@immutable
abstract class GovScreenState {}

class GovScreenInitial extends GovScreenState {}

class GovScreenLoading extends GovScreenState {}

class GovScreenLoaded extends GovScreenState {
  final List<Map<String, dynamic>> govs;
  GovScreenLoaded({required this.govs});
}

class GovScreenError extends GovScreenState {
  final String errorMsg;
  GovScreenError({required this.errorMsg});
}

////////////////////////////////////////////////////////////////////////////////

class GovDetailsLoading extends GovScreenState {}

class GovDetailsLoaded extends GovScreenState {
  final List<LandMark> govs;
  GovDetailsLoaded({required this.govs});
}

class GovDetailsError extends GovScreenState {
  final String errorMsg;
  GovDetailsError({required this.errorMsg});
}
