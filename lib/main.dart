import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/features/Home/component/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/features/Home/splash/ui/splash.dart';
import 'package:tourist_guide/features/Home/tabs/govs/bloc/gov_details_cubit/gov_details_cubit.dart';
import 'package:tourist_guide/features/Home/tabs/govs/ui/gov_details.dart';
import 'package:tourist_guide/features/Home/ui/home.dart';
import 'package:tourist_guide/features/auth/ui/login_screen.dart';
import 'package:tourist_guide/features/auth/ui/signup_screen.dart';
import 'core/blocs/settings_bloc/settings_bloc_bloc.dart';
import 'features/Home/splash/splash_bloc/splash_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/utils/user_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
