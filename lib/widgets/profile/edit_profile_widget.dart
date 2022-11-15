import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paw_pals/constants/app_data.dart';
import 'package:paw_pals/services/firestore_service.dart';
import 'package:paw_pals/widgets/app_image.dart';
import 'package:paw_pals/constants/app_icons.dart';
import 'package:paw_pals/constants/app_info.dart';
import 'package:paw_pals/controllers/app_user.dart';
import 'package:paw_pals/controllers/file_controller.dart';
import 'package:paw_pals/models/user_model.dart';
import 'package:paw_pals/widgets/buttons/contained_button.dart';
import 'package:paw_pals/widgets/fields/our_text_field.dart';
import 'package:paw_pals/widgets/forms/_form_validation.dart';
import 'package:paw_pals/widgets/wrappers/field_wrapper.dart';


/// The EditProfile widget allows the user to change their first and
/// last name and profile photo.

class EditProfile extends StatefulWidget {
  final UserModel? userModel;

  const EditProfile({super.key, this.userModel});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> with FormValidation {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final FileController fileController = FileController();
  final _formKey = GlobalKey<FormState>();

  UserModel? get _userModel => super.widget.userModel;

  String focusedField = "none";

  @override
  void initState() {
    // auto-fill text-fields if userModel data is not null.
    if (_userModel != null) {
      if (_userModel!.first != null) firstNameController.text = _userModel!.first!;
      if (_userModel!.last != null) lastNameController.text = _userModel!.last!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppImage(
              imageUrl: _userModel?.photoUrl,
              controller: fileController,
              defaultImage: AppData.defaultProfile,
              shape: BoxShape.circle,
            ),
            OurTextField(
              labelText: translate("field-labels.first-name"),
              validator: firstNameValidator,
              controller: firstNameController,
              icon: AppIcons.user,
              maxLength: AppInfo.maxNameLength,
            ),
            OurTextField(
              labelText: translate("field-labels.last-name"),
              validator: lastNameValidator,
              controller: lastNameController,
              icon: AppIcons.users,
              maxLength: AppInfo.maxNameLength,
            ),
            FieldWrapper(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ContainedButton(
                        icon: AppIcons.edit,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirestoreService
                              .updateUser(
                                userModel: AppUser.instance.userModel!.copyWith(
                                  first: firstNameController.text.trim(),
                                  last: lastNameController.text.trim()),
                                file: fileController.value)
                              .then((didComplete) => didComplete
                                ? Get.back()
                                : Get.snackbar(
                                'Error: unable to update profile',
                                'Please try again.',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 7),
                                colorText: Theme.of(context).errorColor));
                          }
                        }, label: 'Save Changes', //Button label
                      )
                    ]
                )
            )
          ]
      ),
    );
  }
}