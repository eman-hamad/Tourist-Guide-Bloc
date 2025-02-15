part of 'gov_details_cubit.dart';

@immutable
abstract class GovDetailsState {}

class GovDetailsInitial extends GovDetailsState {}

class GovDetailsLoading extends GovDetailsState {}

class GovDetailsLoaded extends GovDetailsState {
  final List<FSLandMark> govs;
  GovDetailsLoaded({required this.govs});
}

class GovDetailsError extends GovDetailsState {
  final String errorMsg;
  GovDetailsError({required this.errorMsg});
}
