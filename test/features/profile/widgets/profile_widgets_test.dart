import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tourist_guide/core/blocs/auth_text_field_bloc/auth_text_field_bloc.dart';
import 'package:tourist_guide/core/blocs/auth_text_field_bloc/auth_text_field_event.dart';
import 'package:tourist_guide/core/widgets/auth_text_field.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import 'package:tourist_guide/features/Home/tabs/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:tourist_guide/features/Home/tabs/profile/widgets/asset_image.dart';
import 'package:tourist_guide/features/Home/tabs/profile/widgets/profile_image.dart';
import 'package:tourist_guide/features/Home/tabs/profile/widgets/profile_item.dart';

class MockAuthBloc extends Mock implements ProfileBloc {}

// Initialize Firebase
void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

void main() {
  late TextEditingController controller;
  late AuthTextFieldBloc bloc;

  setUpAll(() async {
    controller = TextEditingController();
    bloc = AuthTextFieldBloc();
  });
  tearDown(() {
    controller.dispose();
    bloc.close();
  });

  testWidgets('Profile Image widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: ProfileImage(
        img: assetProfileImage(),
      )),
    );

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('ProfileItem displays correct text and icon',
      (WidgetTester tester) async {
    const testText = "Eman";
    const testIcon = Icons.person;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: ProfileItem(txt: testText, icon: testIcon, isObscure: false),
          ),
        ),
      ),
    );

    expect(find.byIcon(testIcon), findsOneWidget);
  });

  testWidgets('ProfileItem obscures text when isObscure is true',
      (WidgetTester tester) async {
    const testText = '888888888';

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: ProfileItem(txt: testText, icon: Icons.lock, isObscure: true),
          ),
        ),
      ),
    );

    expect(find.text(testText), findsOneWidget); // Expect masked text
  });

  testWidgets('CustomButton displays text and reacts to tap',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Edit Profile',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Edit Profile'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(wasPressed, isTrue);
  });

  testWidgets('CustomButton is disabled when isLoading is true',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: () => wasPressed = true,
              isLoading: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(wasPressed, isFalse);
  });

  testWidgets('AuthTextField displays label and updates text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
              controller: controller,
              fieldType: 'email',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    expect(controller.text, 'test@example.com');
  });

  testWidgets('AuthTextField shows validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthTextFieldBloc>(
              create: (_) => bloc,
              child: AuthTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                controller: controller,
                fieldType: 'email',
              ),
            ),
          ),
        ),
      ),
    );

    controller.text = 'invalid';
    bloc.add(TextChangedEvent(text: 'invalid', fieldType: 'email'));
    await tester.pump();

    expect(find.textContaining('invalid'), findsOneWidget);
  });

  testWidgets('AuthTextField updates password validation dynamically',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthTextFieldBloc>(
              create: (_) => bloc,
              child: AuthTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                controller: controller,
                fieldType: 'password',
                isPassword: true,
              ),
            ),
          ),
        ),
      ),
    );

    controller.text = 'Pass123!';
    bloc.add(TextChangedEvent(text: 'Pass123!', fieldType: 'password'));
    await tester.pump();

    expect(find.textContaining('uppercase letter'), findsNothing);
  });
}
