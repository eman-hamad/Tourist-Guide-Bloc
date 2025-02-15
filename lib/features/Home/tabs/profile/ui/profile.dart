import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../blocs/edit_profile_bloc/edit_profile_bloc.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import '../widgets/asset_image.dart';
import '../widgets/profile_image.dart';
import '../widgets/profile_item.dart';
import '../../../../../core/blocs/settings_bloc/settings_bloc_bloc.dart';
import '../../../../../core/colors/colors.dart';
import '../../../../../core/utils/profile_manager.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger biometric authentication
    context.read<ProfileBloc>().add(SubscribeProfile());
  }

  void removeImage() {
    ProfileManager().removeImage(context);
  }

  @override
  Widget build(BuildContext context) {
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
                          state is ProfileImageLoaded ||
                          state is ProfileImageRemoved,
                      listener: (context, state) {
                        if (state is ProfileImageUploaded) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          CustomSnackBar.showSuccess(
                              context: context,
                              message: "Image Uploaded Successfully");
                        }

                        if (state is ProfileImageRemoved) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          CustomSnackBar.showSuccess(
                              context: context,
                              message: "Image Removed Successfully");
                        }

                        if (state is ProfileImageError) {
                          CustomSnackBar.showError(
                              context: context,
                              message: "Error occurred, Try Again later");
                        }
                      },
                      builder: (context, state) {
                        if (state is ProfileImageLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is ProfileImageLoaded) {
                          return Stack(alignment: Alignment.center, children: [
                            ProfileImage(
                                img: state.image != null
                                    ? MemoryImage(state.image!)
                                    : assetProfileImage()),
                            if (state.image != null)
                              Positioned(
                                bottom: -12.h,
                                left: 65.w,
                                right: 0.w,
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => removeAlert());
                                    },
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      size: 30.w,
                                    ),
                                    color: isDarkMode ? kWhite : kMainColor),
                              ),
                          ]);
                        }

                        if (state is ProfileImageRemoved) {
                          return ProfileImage(img: assetProfileImage());
                        }

                        if (state is ProfileImageError) {
                          return Text(state.errorMessage);
                        }

                        return ProfileImage(
                          img: assetProfileImage(),
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
                            final user = state.user;
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
                                    txt: user!.name,
                                    icon: Icons.person_2_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: user.email,
                                    icon: Icons.email_outlined,
                                  ),
                                  ProfileItem(
                                    txt: '888888888',
                                    isObscure: false,
                                    icon: Icons.lock_open_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: user.phone.isEmpty
                                        ? 'N/A'
                                        : context
                                            .read<ProfileBloc>()
                                            .firebaseUser!
                                            .phone,
                                    icon: Icons.phone_android_outlined,
                                  ),
                                  GestureDetector(
                                    onTap: () => context
                                        .read<ProfileBloc>()
                                        .logout(context),
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
                                                  name: user.name,
                                                  email: user.email,
                                                  phone: user.phone),
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

  Widget removeAlert() {
    return AlertDialog(
      title: Text("Remove Profile Picture"),
      content: Text("Are you sure you want to remove your profile picture?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel",
              style: TextStyle(fontWeight: FontWeight.bold, color: kBlack)),
        ),
        TextButton(
          onPressed: () {
            removeImage();
            Navigator.pop(context);
          },
          child: Text("Remove",
              style: TextStyle(fontWeight: FontWeight.bold, color: kMainColor)),
        ),
      ],
    );
  }
}
