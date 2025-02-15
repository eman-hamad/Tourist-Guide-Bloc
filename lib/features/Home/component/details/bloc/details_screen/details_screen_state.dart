part of 'details_screen_cubit.dart';

class DetailsScreenState {
  final bool showFirst;
  final bool showSecond;
  final bool showThird;
  final bool showFourth;
  final bool showFifth;

  DetailsScreenState({
    required this.showFirst,
    required this.showSecond,
    required this.showThird,
    required this.showFourth,
    required this.showFifth,
  });

  factory DetailsScreenState.initial() => DetailsScreenState(
        showFirst: false,
        showSecond: false,
        showThird: false,
        showFourth: false,
        showFifth: false,
      );

  DetailsScreenState copyWith({
    bool? showFirst,
    bool? showSecond,
    bool? showThird,
    bool? showFourth,
    bool? showFifth,
  }) {
    return DetailsScreenState(
      showFirst: showFirst ?? this.showFirst,
      showSecond: showSecond ?? this.showSecond,
      showThird: showThird ?? this.showThird,
      showFourth: showFourth ?? this.showFourth,
      showFifth: showFifth ?? this.showFifth,
    );
  }
}
