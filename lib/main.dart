import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/login_bloc/login_bloc.dart';
import 'package:tourist_guide/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_bloc.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/ui/auth/login.dart';
import 'package:tourist_guide/ui/governorate/governorate_details.dart';
import 'package:tourist_guide/ui/home/home.dart';
import 'package:tourist_guide/ui/auth/signup.dart';
import 'package:tourist_guide/ui/splash/splash.dart';
import 'package:tourist_guide/ui/landmarks/details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserManager().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginBloc()),
          BlocProvider(create: (_) => SignUpBloc()),
          BlocProvider(create: (_) => SplashScreenBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Suwannaphum',
          ),
          home: SplashScreen(),
          routes: {
            '/login': (context) => Login(),
            '/signup': (context) => Signup(),
            '/home': (context) => const HomeScreen(),
            '/details': (context) => DetailsScreen(),
            '/governate_detials': (context) => GovernorateDetails(),
          },
        ),
      ),

    );
  }
}
