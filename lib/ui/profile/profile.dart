import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:tourist_guide/bloc/profile_bloc/profile_bloc.dart';
import 'package:tourist_guide/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';
import 'package:tourist_guide/ui/profile/widgets/profile_image.dart';
import 'edit_profile.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout() async {
    UserManager.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // load data from firebase
    context.read<ProfileBloc>().add(LoadSavedImage());
    context.read<ProfileBloc>().add(LoadHeaderData());
    context.read<ProfileBloc>().add(LoadProfile());

    //check the theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: REdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("My Profile",
                            style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? kGrey : kBlack)),
                        SizedBox(
                          width: 190.w,
                        ),
                        BlocBuilder<SettingsBlocBloc, SettingsBlocState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<SettingsBlocBloc>()
                                    .add(ToggleTheme());
                              },
                              child: Icon(
                                state is SettingsBlocThemeLight
                                    ? Icons.dark_mode
                                    : Icons.sunny,
                                color: isDarkMode ? kDarkTexe : kBlack,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    // listen to states and rebuild ui
                    BlocConsumer<ProfileBloc, ProfileState>(
                      buildWhen: (context, state) =>
                          state is ProfileImageLoaded,
                      listener: (context, state) {
                        if (state is ProfileImageUploaded) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Image Uploaded Successfully")),
                          );
                        }

                        if (state is ProfileImageError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Error occurred, Try Again later")),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ProfileImageLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is ProfileImageLoaded) {
                          return ProfileImage(
                              img: CircleAvatar(
                                  radius: 50.r,
                                  backgroundImage: FileImage(state.image)));
                        }

                        if (state is ProfileImageError) {
                          return Text(state.errorMessage);
                        }

                        return ProfileImage(
                          img: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: const AssetImage(
                                  "assets/images/profile.png")),
                        );
                      },
                    ),
                    // rebuild ui
                    BlocBuilder<ProfileBloc, ProfileState>(
                        buildWhen: (context, state) => state is ProfileLoaded,
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is ProfileLoaded) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: REdgeInsets.only(top: 8.h),
                                      child: Text(
                                          context.read<ProfileBloc>().firstName,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context
                                        .read<ProfileBloc>()
                                        .firebaseUser!
                                        .name,
                                    icon: Icons.person_2_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context
                                        .read<ProfileBloc>()
                                        .firebaseUser!
                                        .email,
                                    icon: Icons.email_outlined,
                                  ),
                                   ProfileItem(
                                     txt: '888888888',
                                     isObscure: false,
                                     icon: Icons.lock_open_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context
                                            .read<ProfileBloc>()
                                            .firebaseUser!
                                            .phone
                                            .isEmpty
                                        ? 'N/A'
                                        : context
                                            .read<ProfileBloc>()
                                            .firebaseUser!
                                            .phone,
                                    icon: Icons.phone_android_outlined,
                                  ),
                                  GestureDetector(
                                    onTap: () => _logout(),
                                    child: ProfileItem(
                                      isObscure: true,
                                      txt: "Log out",
                                      icon: Icons.logout_outlined,
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  CustomButton(
                                      text: "Edit Profile   ✍️",
                                      fontSize: 36,
                                      width: 200.w,
                                      height: 100.h,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (con) => BlocProvider(
                                              create: (context) =>
                                                  EditProfileBloc(),
                                              child: EditProfile(
                                                name: context
                                                    .read<ProfileBloc>()
                                                    .firebaseUser!
                                                    .name,
                                                email: context
                                                    .read<ProfileBloc>()
                                                    .firebaseUser!
                                                    .email,
                                                phone: context
                                                    .read<ProfileBloc>()
                                                    .firebaseUser!
                                                    .phone,
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                ]);
                          }
                          if (state is ProfileError) {
                            return Center(child: Text(state.errorMessage));
                          }
                          return Container();
                        }),
                  ],
                ))));
  }
}
