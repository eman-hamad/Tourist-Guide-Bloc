import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/Home/tabs/profile/blocs/profile_bloc/profile_bloc.dart';

// profile logic
class ProfileManager {
  void uploadImage(BuildContext context) {
    context.read<ProfileBloc>().add(UpdateAvatar());
  }

  void removeImage(BuildContext context) {
    context.read<ProfileBloc>().add(ImageRemoved());
  }
}
