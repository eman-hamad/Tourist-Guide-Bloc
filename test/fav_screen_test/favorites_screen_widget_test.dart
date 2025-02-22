import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourist_guide/features/Home/bloc/home_cubit/home_cubit.dart';
import 'package:tourist_guide/features/Home/tabs/favorites/widgets/empty_favs.dart';

void main() {
  testWidgets('EmptyFavs displays correct UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) =>
            MaterialApp(home: Scaffold(body: EmptyFavs())),
      ),
    );

    expect(find.byIcon(Icons.favorite_outline_rounded), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text
                .toPlainText()
                .contains("Your Favorite List is Empty! Explore Places"),
      ),
      findsOneWidget,
    );
  });

}
