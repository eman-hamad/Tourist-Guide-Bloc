part of 'details_screen_cubit.dart';

class DetailsScreenState {
  final bool showFirst;
  final bool showSecond;
  final bool showThird;
  final bool showFourth;

  DetailsScreenState({
    required this.showFirst,
    required this.showSecond,
    required this.showThird,
    required this.showFourth,
  });

  factory DetailsScreenState.initial() => DetailsScreenState(
        showFirst: false,
        showSecond: false,
        showThird: false,
        showFourth: false,
      );

  DetailsScreenState copyWith({
    bool? showFirst,
    bool? showSecond,
    bool? showThird,
    bool? showFourth,
  }) {
    return DetailsScreenState(
      showFirst: showFirst ?? this.showFirst,
      showSecond: showSecond ?? this.showSecond,
      showThird: showThird ?? this.showThird,
      showFourth: showFourth ?? this.showFourth,
    );
  }

 }
