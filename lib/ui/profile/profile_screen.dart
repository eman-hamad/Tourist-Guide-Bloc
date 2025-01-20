import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import '../../core/colors/colors.dart';
import '../../data/models/user_model.dart';
import 'edit_profile.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences? prefs;
  File? _image;
  User user = User(email: "", id: "", name: "", password: "", phone: "");

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    final existingUserString = prefs?.getString('current_user');
    final imagePath = prefs?.getString('img');

    if (existingUserString != null) {
      final userData = jsonDecode(existingUserString);
      user = User.fromJson(userData);
    }

    if (imagePath != null) {
      _image = File(imagePath);
    }

    setState(() {});
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/${pickedFile.name}';
      final File savedImage = await File(pickedFile.path).copy(newPath);

      prefs?.setString('img', savedImage.path);

      setState(() {
        _image = savedImage;
      });
    }
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
            vertical: 15,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("My Profile",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          _pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60.0.r)),
                              border: Border.all(
                                  color: kMainColor,
                                  width: 8.w,
                                  style: BorderStyle.solid)),
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage(
                                    "assets/images/profile.png",
                                  ) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: REdgeInsets.only(top: 8),
                        child: Text(user.name,
                            style: TextStyle(
                                fontSize: 21.sp, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            // reusable widget to implement the Row item
            ProfileItem(
              isObscure: true,
              txt: user.name,
              icon: Icons.person_2_outlined,
            ),
            ProfileItem(
              isObscure: true,
              txt: user.email,
              icon: Icons.email_outlined,
            ),
            ProfileItem(
              txt: user.password,
              isObscure: false,
              icon: Icons.lock_open_outlined,
            ),
            ProfileItem(
              isObscure: true,
              txt: user.phone,
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
            SizedBox(
              height: 60.h,
            ),
            CustomButton(
                text: "Edit Profile   ✍️",
                fontSize: 36,
                width: 200.w,
                height: 100.h,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(
                        name: user.name,
                        email: user.email,
                        password: user.password,
                        phone: user.phone,
                      ),
                    ),
                  );
                })
          ]),
        ),
      ),
    );
  }
}