import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';
import 'package:tourist_guide/features/auth/bloc/auth_states.dart';
import 'package:tourist_guide/features/auth/ui/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mocks/mock.mocks.dart';



void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => Material(
          child: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const SignUpView(),
          ),
        ),
      ),
    );
  }

  group('SignUpScreen', () {
    testWidgets('renders all required widgets', (WidgetTester tester) async {
      // Set viewport size
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Basic widget checks
      expect(find.text('Sign up!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('can fill form fields', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Fill form fields
      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.pump();

      await tester.enterText(
          find.byType(TextFormField).at(1), 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('can toggle password visibility', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find password field and visibility icon
      final passwordField = find.byType(TextFormField).at(2);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Find and tap visibility toggle
      final visibilityIcon = find.byIcon(Icons.visibility).first;
      await tester.tap(visibilityIcon);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });

  // tearDown(() {
  //   addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  // });
}
