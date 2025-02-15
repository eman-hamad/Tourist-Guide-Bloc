part of 'gov_screen_cubit.dart';

@immutable
abstract class GovScreenState {}

class GovScreenInitial extends GovScreenState {}

class GovScreenLoading extends GovScreenState {}

class GovScreenLoaded extends GovScreenState {
  final List<GovernorateModel> govs;
  GovScreenLoaded({required this.govs});
}

class GovScreenError extends GovScreenState {
  final String errorMsg;
  GovScreenError({required this.errorMsg});
}
