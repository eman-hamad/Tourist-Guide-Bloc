import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/profile_bloc/profile_bloc.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/ui/landmarks/fav_screen.dart';
import 'package:tourist_guide/ui/governorate/govs_screen.dart';
import 'package:tourist_guide/ui/landmarks/places_screen.dart';
import 'package:tourist_guide/ui/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  final PageController _pageController = PageController();

// Constructs the Home screen UI, which includes a body with
// a PageView and a bottom curved navigation bar.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.enableScale(enableWH: () => true, enableText: () => true);
    return Scaffold(
      body: _body(),
      bottomNavigationBar: _curvedNavBar(),
    );
  }

// Creates a PageView widget that allows the user to swipe between
// different screens (Places, Gov, Fav, and Profile) with a controlled navigation.
  Widget _body() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BlocProvider(
          create: (context) => ProfileBloc(),
          child: PlacesScreen(
            onNavigate: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                pageIndex = index;
              });
            },
          ),
        ),
        const GovernorateScreen(),
        const FavoritesScreen(),
        BlocProvider(
          create: (context) => ProfileBloc(),
          child: ProfileScreen(),
        )
      ],
    );
  }

// Builds the curved navigation bar with icons for different screens. It allows
// the user to switch between screens using a tap, and it animates the page transition.
  _curvedNavBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CurvedNavigationBar(
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
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceInOut,
              );

              setState(() {
                pageIndex = index;
              });
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

// Disposes of the PageController when the HomeScreen is removed from the
// widget tree to free up resources.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
