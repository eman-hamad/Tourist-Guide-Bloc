import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/gov_screen/gov_screen_cubit.dart';
import 'package:tourist_guide/bloc/login_bloc/login_bloc.dart';
import 'package:tourist_guide/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:tourist_guide/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_bloc.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/data/models/fire_store_goverorate_model.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';
import 'package:tourist_guide/ui/auth/login.dart';
import 'package:tourist_guide/ui/landmarks/govs/screens/gov_details.dart';
import 'package:tourist_guide/ui/home/home.dart';
import 'package:tourist_guide/ui/auth/signup.dart';
import 'package:tourist_guide/ui/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserManager().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/login': (context) => _login(),
        '/signup': (context) => _signup(),
        '/home': (context) => const HomeScreen(),
        '/governate_detials': (context) => _govDetails(),
      },
    );
  }

  Widget _splash() {
    return BlocProvider(
      create: (_) => SplashScreenBloc(),
      child: const SplashScreen(),
    );
  }

  Widget _login() {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const Login(),
    );
  }

  Widget _signup() {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: const Signup(),
    );
  }

  Widget _govDetails() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GovScreenCubit()),
        BlocProvider(create: (context) => FavBloc()),
      ],
      child: const GovernorateDetails(),
    );
  }
}
