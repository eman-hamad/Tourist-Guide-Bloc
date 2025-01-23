part of 'edit_profile_bloc.dart';

// edit profile events
abstract class EditProfileEvent {}

class SaveEdits extends EditProfileEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  SaveEdits({
    required this.context,
    required this.formKey,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}
