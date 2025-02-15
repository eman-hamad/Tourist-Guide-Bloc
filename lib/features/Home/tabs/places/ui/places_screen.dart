import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/data/dummy/dummy_data.dart';
import 'package:tourist_guide/features/Home/tabs/places/bloc/places_screen_cubit.dart';
import 'package:tourist_guide/features/Home/tabs/places/widgets/header.dart';
import 'package:tourist_guide/features/Home/tabs/places/widgets/pop_places.dart';
import 'package:tourist_guide/features/Home/tabs/places/widgets/sug_places.dart';
import 'package:tourist_guide/features/Home/tabs/profile/blocs/profile_bloc/profile_bloc.dart';
import '../../../../../core/colors/colors.dart';

class PlacesScreen extends StatelessWidget {
  final void Function(int)? onNavigate;
  const PlacesScreen({super.key, this.onNavigate});

  void _triggerLoadingDataEvents(BuildContext context) {
    context.read<ProfileBloc>().add(LoadHeaderData());
    // context.read<PlacesBloc>().add(LoadPlacesEvent());
  }

// The main UI of the PlacesScreen is built with padding and two main components:
// the header and body. The header displays a personalized greeting, and the body
// contains two sections for places.
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    _triggerLoadingDataEvents(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh - 75,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _header(context),
                _body(context, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

// The Header of the screen that contains the user name, profile photo and a welcome message
  Widget _header(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is HeaderDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          // In loading state show a loading widget
          if (state is ProfileLoading) {
            return Skeletonizer(
              enabled: true,
              child: PlacesHeader(name: 'User', imgPath: null),
            );
          }
          // In loaded state show the real data
          else if (state is HeaderLoaded) {
            return PlacesHeader(name: state.firstName, imgPath: state.image);
          }
          // Otherwise show the default data
          else {
            return PlacesHeader(name: 'User', imgPath: null);
          }
        },
      ),
    );
  }

  Widget _body(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: Column(
        children: [
          _suggestedPlaces(context, isDarkMode),
          _popularPlaces(context, isDarkMode),
        ],
      ),
    );
  }

// GridView of Suggested Places
  Widget _suggestedPlaces(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 0.53.sh - 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.01.sh),
          Text(
            'Suggested Places',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? kMainColorDark : kMainColor),
          ),
          SizedBox(height: 0.01.sh),

          // Load the data from the PlacesBloc using a BlocBuilder
          BlocBuilder<PlacesScreenCubit, PlacesScreenState>(
            builder: (context, state) {
              // In loading state show a loading widget
              if (state is PlacesScreenLoadingState) {
                return SugPlaces(
                  loading: true,
                  itemCount: 4,
                  places: List.filled(4, kDummyData),
                  hasMore: false,
                  onLoadMore: () {},
                );
              }
              // In loaded state show the data
              else if (state is PlacesScreenLoadedState) {
                return SugPlaces(
                  loading: false,
                  itemCount: state.sugPlaces.length,
                  places: state.sugPlaces,
                  hasMore: state.hasMore,
                  onLoadMore: () {
                    // Trigger the Bloc event to load more places
                    context.read<PlacesScreenCubit>().loadMorePlaces();
                  },
                );
              }
              // In Error state show the error msg
              else if (state is PlacesScreenErrorState) {
                return Expanded(child: Text(state.errorMsg));
              }
              // If something wrong happend show an error msg
              else {
                return Expanded(
                  child: Center(
                    child: Text('Something wrong happend\n $state'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

// List of Popular Places
  Widget _popularPlaces(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 0.41.sh - 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.01.sh),
          Text(
            'Popular Places',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? kMainColorDark : kMainColor,
            ),
          ),
          SizedBox(height: 0.01.sh),

          // Load the data from the PlacesBloc using a BlocBuilder
          BlocBuilder<PlacesScreenCubit, PlacesScreenState>(
            builder: (context, state) {
              // In loading state show a loading widget
              if (state is PlacesScreenLoadingState) {
                return PopPlaces(
                  loading: true,
                  itemCount: 4,
                  places: List.filled(4, kDummyData),
                );
              }
              // In loaded state show the data
              else if (state is PlacesScreenLoadedState) {
                return PopPlaces(
                  loading: false,
                  itemCount: state.popPlaces.length,
                  places: state.popPlaces,
                );
              }
              // In Error state show the error msg
              else if (state is PlacesScreenErrorState) {
                return Expanded(child: Text(state.errorMsg));
              }
              // If something wrong happend show an error msg
              else {
                return Expanded(
                  child: Center(
                    child: Text('Something wrong happend\n$state'),
                  ),
                );
              }
            },
          ),

          SizedBox(height: 0.005.sh),
        ],
      ),
    );
  }
}
