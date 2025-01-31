import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_screen_cubit/fav_screen_cubit.dart';
import 'package:tourist_guide/bloc/data_blocs/gov_screen/gov_screen_cubit.dart';
import 'package:tourist_guide/bloc/data_blocs/places_bloc/places_data_bloc.dart';
import 'package:tourist_guide/bloc/home_cubit/home_cubit.dart';
import 'package:tourist_guide/bloc/profile_bloc/profile_bloc.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/ui/landmarks/favs/screens/fav_screen.dart';
import 'package:tourist_guide/ui/landmarks/govs/screens/govs_screen.dart';
import 'package:tourist_guide/ui/landmarks/places/screen/places_screen.dart';
import 'package:tourist_guide/ui/profile/profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.enableScale(enableWH: () => true, enableText: () => true);
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final PageController _pageController = PageController();

// Constructs the Home screen UI, which includes a body with
// a PageView and a bottom curved navigation bar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeCubit, int>(
        listener: (context, pageIndex) {
          _pageController.animateToPage(
            pageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: _body(),
      ),
      bottomNavigationBar: _curvedNavBar(context),
    );
  }

// Creates a PageView widget that allows the user to swipe between
// different screens (Places, Gov, Fav, and Profile) with a controlled navigation.
  Widget _body() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PlacesBloc()),
            BlocProvider(create: (context) => FavBloc()),
            BlocProvider(create: (context) => ProfileBloc()),
          ],
          child: const PlacesScreen(),
        ),
        BlocProvider(
          create: (context) => GovScreenCubit(),
          child: GovernorateScreen(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FavBloc()),
            BlocProvider(
              create: (context) => FavScreenCubit(
                favBloc: context.read<FavBloc>(),
              ),
            ),
          ],
          child: const FavoritesScreen(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
          child: ProfileScreen(),
        )
      ],
    );
  }

// Builds the curved navigation bar with icons for different screens. It allows
// the user to switch between screens using a tap, and it animates the page transition.
  Widget _curvedNavBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<HomeCubit, int>(
            builder: (context, pageIndex) {
              return CurvedNavigationBar(
                index: pageIndex,
                backgroundColor: Colors.transparent,
                color: isDarkMode ? kMainColorDark : kMainColor,
                items: [
                  Icon(Icons.home_rounded, size: 30),
                  Icon(Icons.place_rounded, size: 30),
                  Icon(Icons.favorite_rounded, size: 30),
                  Icon(Icons.person_rounded, size: 30),
                ],
                onTap: (index) {
                  context.read<HomeCubit>().navigateToPage(index);
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _navBarTxt('Places'),
                _navBarTxt('Governorates'),
                _navBarTxt('Favorits'),
                _navBarTxt('Profile'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _navBarTxt(String txt) {
    return Expanded(
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
