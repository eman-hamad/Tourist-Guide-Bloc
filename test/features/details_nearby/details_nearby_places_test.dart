import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/features/Home/component/details/widgets/nearby_places.dart';
import 'package:tourist_guide/features/Home/component/details/bloc/nearbyPlacesCubit/nearby_places_cubit.dart';
import 'package:tourist_guide/features/Home/component/details/bloc/details_screen/details_screen_cubit.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:flutter/services.dart';

class MockNearbyPlacesCubit extends MockCubit<NearbyPlacesState>
    implements NearbyPlacesCubit {}

class MockDetailsScreenCubit extends MockCubit<DetailsScreenState>
    implements DetailsScreenCubit {}

void main() {
  late MockNearbyPlacesCubit mockNearbyCubit;
  late MockDetailsScreenCubit mockDetailsCubit;
  late FSLandMark testLandmark;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null;

    mockNearbyCubit = MockNearbyPlacesCubit();
    mockDetailsCubit = MockDetailsScreenCubit();

    testLandmark = FSLandMark(
      id: "1",
      name: "Test Landmark",
      governorate: "Test City",
      rate: 4.5,
      description: "A beautiful place",
      imgUrls: ["https://example.com/image.jpg"],
      location: GeoPoint(30.0444, 31.2357),
    );

    when(() => mockDetailsCubit.state).thenReturn(DetailsScreenState(
      showFirst: true,
      showSecond: true,
      showThird: true,
      showFourth: true,
      showFifth: true,
    ));
  });

  Widget createTestWidget({required NearbyPlacesState nearbyState}) {
    when(() => mockNearbyCubit.state).thenReturn(nearbyState);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<NearbyPlacesCubit>.value(value: mockNearbyCubit),
              BlocProvider<DetailsScreenCubit>.value(value: mockDetailsCubit),
            ],
            child: Scaffold(
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 400.h,
                    maxHeight: 600.h,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: AnimatedNearbyPlaces(
        landMark: testLandmark,
        isDarkMode: false,
      ),
    );
  }

  testWidgets("Displays loading state correctly", (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestWidget(nearbyState: NearbyPlacesLoading()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Displays nearby places when loaded",
      (WidgetTester tester) async {
    final List<FSLandMark> mockPlaces = [
      FSLandMark(
        id: "2",
        name: "Nearby Place",
        governorate: "Nearby City",
        rate: 4.2,
        description: "A nice place nearby",
        imgUrls: ["https://example.com/nearby.jpg"],
        location: GeoPoint(30.045, 31.236),
      )
    ];

    await tester.pumpWidget(createTestWidget(
        nearbyState: NearbyPlacesLoaded(nearbyPlaces: mockPlaces)));
    await tester.pump();

    expect(find.text("Nearby Places"), findsOneWidget);
    expect(find.text("Nearby Place"), findsOneWidget);
  });

  testWidgets("Displays error message when NearbyPlacesError state",
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
        nearbyState: NearbyPlacesError(errorMsg: "Failed to load places")));
    await tester.pump();

    expect(find.text("Failed to load places"), findsOneWidget);
  });
}
