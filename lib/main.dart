import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/gov_details_cubit/gov_details_cubit.dart';
import 'package:tourist_guide/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_bloc.dart';
import 'package:tourist_guide/core/di/service_locator.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/ui/auth/signup_screen.dart';
import 'package:tourist_guide/ui/landmarks/govs/screens/gov_details.dart';
import 'package:tourist_guide/ui/home/home.dart';
import 'package:tourist_guide/ui/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserManager().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Service Locator
  await ServiceLocator.initialize();
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
      child: BlocProvider(
        create: (context) => SettingsBlocBloc(),
        child: BlocBuilder<SettingsBlocBloc, SettingsBlocState>(
          builder: (context, state) {
            ThemeData? theme;
            if (state is SettingsBlocThemeLight) {
              theme = state.lightTh;
            } else if (state is SettingsBlocThemeDark) {
              theme = state.darkTh;
            }
            return _materialApp(theme);
          },
        ),
      ),
    );
  }

  MaterialApp _materialApp(ThemeData? theme) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: SplashScreen(),
      routes: {
        '/splash': (context) => _splash(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/governate_detials': (context) => _govDetails(),
      },
    );
  }

  Widget _splash() {
    return BlocProvider(
      create: (_) => SplashBloc(
        authService: ServiceLocator.get(),
        userRepository: ServiceLocator.get(),
      ),
      child: const SplashScreen(),
    );
  }



  Widget _govDetails() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GovDetailsCubit()),
        BlocProvider(create: (context) => FavBloc.getInstance()),
      ],
      child: const GovernorateDetails(),
    );
  }
}
