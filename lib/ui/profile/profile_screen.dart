import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import 'package:tourist_guide/cubits/profile_cubit/profile_cubit.dart';
import 'package:tourist_guide/ui/profile/widgets/profile_image.dart';
import 'edit_profile.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
 // get user's data and load img
    context.read<ProfileCubit>().getData();
    context.read<ProfileCubit>().loadSavedImage();
  }

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
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: REdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Column(
                  children: [
                    Text("My Profile",
                        style: TextStyle(
                            fontSize: 28.sp, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10.h,
                    ),
                    // listen to states and rebuild ui
                    BlocConsumer<ProfileCubit, ProfileState>(
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
                    BlocBuilder<ProfileCubit, ProfileState>(
                        buildWhen: (context, state) =>
                            state is ProfileLoaded,
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
                                          context.read<ProfileCubit>().user.name,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context.read<ProfileCubit>().user.name,
                                    icon: Icons.person_2_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context.read<ProfileCubit>().user.email,
                                    icon: Icons.email_outlined,
                                  ),
                                  ProfileItem(
                                    txt:
                                        context.read<ProfileCubit>().user.password,
                                    isObscure: false,
                                    icon: Icons.lock_open_outlined,
                                  ),
                                  ProfileItem(
                                    isObscure: true,
                                    txt: context.read<ProfileCubit>().user.phone,
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
                                  // SizedBox(
                                  //   height: 60.h,
                                  // ),
                                  CustomButton(
                                      text: "Edit Profile   ✍️",
                                      fontSize: 36,
                                      width: 200.w,
                                      height: 100.h,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (con) => EditProfile(
                                              name: context
                                                  .read<ProfileCubit>()
                                                  .user
                                                  .name,
                                              email: context
                                                  .read<ProfileCubit>()
                                                  .user
                                                  .email,
                                              password: context
                                                  .read<ProfileCubit>()
                                                  .user
                                                  .password,
                                              phone: context
                                                  .read<ProfileCubit>()
                                                  .user
                                                  .phone,
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
