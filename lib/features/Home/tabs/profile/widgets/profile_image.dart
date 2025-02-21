import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/utils/profile_manager.dart';
class ProfileImage extends StatelessWidget {
  final ImageProvider<Object>? img;
  final BuildContext? context;

  ProfileImage({
    super.key,
    required this.img,
    this.context,
  });


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          child: InkWell(
            onTap: () {

              // call updateAvatar from bloc to upload img
          showBottomSheet(context);
            },
            child: Container(
                color: isDarkMode ? kDarkBody : kWhite,
                child: CircleAvatar(radius: 50.r, backgroundImage: img)),

              
            // },
            // child: Container(
            //   color: isDarkMode ? Colors.grey[800] : Colors.white,
            //   child: CircleAvatar(
            //     radius: 50.0,
            //     backgroundImage: img,
            //   ),
            ),

          ),
        ),
      
    );
  }


  // Show bottom sheet for options (Camera, Gallery, Remove)
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Camera
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  uploadCamera();
                },
              ),
              // Gallery
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  uploadGallery();
                },
              ),
              // Remove
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Remove'),
                onTap: () {
                  Navigator.pop(context);
                  //  image removal
                  removeImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void uploadGallery() {
    ProfileManager().uploadImage(context!, false);
  }

  void uploadCamera() {
    ProfileManager().uploadImage(context!, true);
  }

  void removeImage() {
    ProfileManager().removeImage(context!);
  }
}
