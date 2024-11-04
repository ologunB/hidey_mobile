import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:mms_app/core/view_models/auth_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/custom_button.dart';
import 'package:mms_app/views/widgets/login_field.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../widgets/back_button.dart';

class CreatePassword extends StatefulWidget {
  CreatePassword({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    Key? key,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final String email;
  final String userName;

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  bool autoValidate = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (_, AuthViewModel model, __) => Form(
        key: formKey,
        autovalidateMode:
            autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xffF5F5F5),
            leading: HideyBackButton(),
            centerTitle: true,
            title: RegularText(
              'Create password',
              color: const Color(0xff1A1A1A),
              fontSize: 24.sp,
              height: 29 / 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            children: [
              RegularText(
                'Create password',
                fontSize: 16.sp,
                height: 19 / 16,
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 4.h,
              ),
              LoginFormField(
                hintMessage: '**********',
                obscureTexts: hidePassword,
                controller: password,
                suffixIcon: IconButton(
                  onPressed: () {
                    hidePassword = !hidePassword;
                    setState(() {});
                  },
                  splashRadius: 20,
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 24.h,
                    color: AppColors.primaryColor,
                  ),
                ),
                validator: (a) {
                  return Utils.isValidPassword(a!);
                },
              ),
              SizedBox(height: 20.h),
              RegularText(
                'Confirm password',
                fontSize: 16.sp,
                height: 19 / 16,
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              LoginFormField(
                hintMessage: '**********',
                controller: cPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    hideConfirmPassword = !hideConfirmPassword;
                    setState(() {});
                  },
                  splashRadius: 20,
                  icon: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 24.h,
                    color: AppColors.primaryColor,
                  ),
                ),
                obscureTexts: hideConfirmPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  } else if (value != password.text) {
                    return "Passwords are different";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              Wrap(
                children: (suggestions ?? [])
                    .map((e) => Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              selectedUsername = e;
                              setState(() {});
                            },
                            child: Chip(
                              backgroundColor: selectedUsername == e
                                  ? AppColors.primaryColor
                                  : null,
                              label: RegularText(
                                e,
                                fontSize: 16.sp,
                                color: selectedUsername == e
                                    ? AppColors.white
                                    : AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 30.h),
              GeneralButton(
                text: 'Create Account',
                onPressed: model.busy
                    ? null
                    : () async {
                        autoValidate = true;
                        setState(() {});
                        if (formKey.currentState!.validate()) {
                          Utils.offKeyboard();
                          Map<String, dynamic> userData = {
                            'FirstName': widget.firstName,
                            'LastName': widget.lastName,
                            'Email': widget.email,
                            'UserName': selectedUsername ?? widget.userName,
                            'Password': password.text,
                          };

                          suggestions = await model.signup(userData);
                          setState(() {});
                        }
                      },
                loading: model.busy,
                primColor: AppColors.primaryColor,
                textColor: const Color(0xffFFFFFF),
                borderColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic>? suggestions;
  String? selectedUsername;
}
