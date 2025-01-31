part of 'fav_btn_bloc.dart';

@immutable
abstract class FavEvent {}

class ToggleFavoriteEvent extends FavEvent {
  final String? placeId;
  ToggleFavoriteEvent({required this.placeId});
}
