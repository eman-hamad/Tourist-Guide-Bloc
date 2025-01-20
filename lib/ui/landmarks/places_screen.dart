import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/cubits/profile_cubit/profile_cubit.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';
import 'package:tourist_guide/ui/landmarks/widgets/header.dart';

class PlacesScreen extends StatelessWidget {
  final void Function(int)? onNavigate;
  const PlacesScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh - 75,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _header(context),
                _body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    context.read<ProfileCubit>().loadSavedImage();
    return SafeArea(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileImageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileImageLoading) {
            return Skeletonizer(
              enabled: true,
              child: Header(name: 'User', imgPath: ''),
            );
          } //
          else if (state is ProfileInitial) {
            return Header(name: 'User', imgPath: '');
          } //
          else if (state is ProfileImageLoaded) {
            return Header(name: 'User', imgPath: state.image.path);
          } //
          else {
            return Text('Error');
          }
        },
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Column(
        children: [
          _suggestedPlaces(),
          _popularPlaces(),
        ],
      ),
    );
  }

// GridView of Suggested Places
  Widget _suggestedPlaces() {
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
            ),
          ),
          SizedBox(height: 0.01.sh),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: PlacesData().suggestedPlaces().length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) => LandmarkCard(
                place: PlacesData().suggestedPlaces()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

// List of Popular Places
  Widget _popularPlaces() {
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
            ),
          ),
          SizedBox(height: 0.01.sh),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PlacesData().popularPlaces().length,
              itemBuilder: (context, index) {
                return LandmarkCard(
                  place: PlacesData().popularPlaces()[index],
                );
              },
            ),
          ),
          SizedBox(height: 0.005.sh),
        ],
      ),
    );
  }
}
