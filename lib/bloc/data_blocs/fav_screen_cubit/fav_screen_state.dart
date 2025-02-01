part of 'fav_screen_cubit.dart';

@immutable
abstract class FavScreenState {}

class FavScreenInitial extends FavScreenState {}

class FavScreenLoading extends FavScreenState {}

class FavScreenLoaded extends FavScreenState {
  final List<FSLandMark> favs;
  FavScreenLoaded({required this.favs});
}

class FavScreenError extends FavScreenState {
  final String errorMsg;
  FavScreenError(this.errorMsg);
}
