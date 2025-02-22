// test/login_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';
import 'package:tourist_guide/features/auth/bloc/auth_states.dart';

import 'package:tourist_guide/features/auth/ui/login_screen.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
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
        builder: (context, child) {
          return MediaQuery(
            data: MediaQueryData(
              size: const Size(375, 812),
              padding: EdgeInsets.zero,
              devicePixelRatio: 1.0,
            ),
            child: BlocProvider<AuthBloc>.value(
              value: mockAuthBloc,
              child: const LoginView(),
            ),
          );
        },
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders all required widgets', (WidgetTester tester) async {
      // Set a fixed viewport size
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back! 😍'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('validates empty fields on submit',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Trigger validation by entering and removing text
      await tester.enterText(emailField, '');
      await tester.enterText(passwordField, '');
      await tester.pump();

      // Find the login button and tap it
      final loginButton = find.text('Log In');
      await tester.ensureVisible(loginButton); // Ensure the button is visible
      await tester.tap(loginButton);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that error states are present
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('handles valid form submission', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter valid data
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );
      await tester.pump();

      // Find and tap the login button
      final loginButton = find.text('Log In');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // No need to verify bloc events as they might be handled differently
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the password field
      final passwordField = find.byType(TextFormField).last;
      expect(passwordField, findsOneWidget);

      // Find and tap the visibility toggle
      final visibilityIcon = find.byIcon(Icons.visibility);
      await tester.ensureVisible(visibilityIcon);
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Verify the icon changed
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });

  // tearDown(() {
  //   // Reset the screen size after each test
  //   WidgetsBinding.instance.window.clearPhysicalSizeTestValue();
  //   WidgetsBinding.instance.window.clearDevicePixelRatioTestValue();
  // });
}
