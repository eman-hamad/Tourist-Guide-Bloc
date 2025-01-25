part of 'fav_btn_bloc.dart';

@immutable
abstract class FavEvent {}

class ToggleFavoriteEvent extends FavEvent {
  final int placeId;
  ToggleFavoriteEvent({required this.placeId});
}
