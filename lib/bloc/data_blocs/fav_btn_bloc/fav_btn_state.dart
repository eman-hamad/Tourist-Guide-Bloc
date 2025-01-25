part of 'fav_btn_bloc.dart';

@immutable
abstract class FavState {}

class FavInitial extends FavState {}

class FavLoading extends FavState {}

class FavLoaded extends FavState {
  final List<LandMark> favs;
  FavLoaded({required this.favs});
}

class FavoriteToggled extends FavState {
  final bool isFav;
  FavoriteToggled({required this.isFav});
}

class FavError extends FavState {
  final String errorMsg;
  FavError({required this.errorMsg});
}
