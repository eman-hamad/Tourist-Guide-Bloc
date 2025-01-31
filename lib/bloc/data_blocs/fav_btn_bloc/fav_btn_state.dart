part of 'fav_btn_bloc.dart';

@immutable
abstract class FavState {}

class FavInitial extends FavState {}

class FavLoading extends FavState {}

class FavoriteToggled extends FavState {
  final List<String> isFav;
  FavoriteToggled({required this.isFav});
}

class FavError extends FavState {
  final String errorMsg;
  FavError({required this.errorMsg});
}
