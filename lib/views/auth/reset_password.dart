import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/custom_image.dart';

import '../widgets/back_button.dart';
import '../widgets/text_widgets.dart';
import '../widgets/utils.dart';
import '../../core/view_models/auth_vm.dart';
import '../widgets/base_view.dart';
import '../widgets/custom_button.dart';
import '../widgets/login_field.dart';
import '../widgets/pincode.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.email}) : super(key: key);

  final String email;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool showPass = true;
  bool showPass2 = true;

  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String pin = '';
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (_, AuthViewModel model, __) => Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: RegularText(
            'Reset password',
            color: const Color(0xff000000),
            fontSize: 24.h,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: const Color(0xffF5F5F5),
          leading: HideyBackButton(),
        ),
        body: Form(
          key: formKey,
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
            children: [
              Center(child: HideyImage('reset', both: 215.h)),
              SizedBox(height: 40.h),
              RegularText(
                'Enter the Code',
                fontSize: 16.sp,
                height: 19 / 16,
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.w500,
              ),
              PinCode(onChanged: (a) {
                if (a.length == 6) {
                  focusNode.requestFocus();
                }
                setState(() => pin = a);
              }),
              if (pin.length == 6)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      'Create new password',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 4.h),
                    LoginFormField(
                      hintMessage: '**********',
                      focusNode: focusNode,
                      obscureTexts: showPass,
                      controller: password,
                      suffixIcon: HideyImage(
                        'EyeSlash',
                        both: 24.h,
                        onTap: () {
                          showPass = !showPass;
                          setState(() {});
                        },
                        color: AppColors.primaryColor,
                      ),
                      validator: (a) {
                        return Utils.isValidPassword(a!);
                      },
                    ),
                    SizedBox(height: 25.h),
                    RegularText(
                      'Confirm new password',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 4.h),
                    LoginFormField(
                      hintMessage: '**********',
                      obscureTexts: showPass2,
                      controller: cPassword,
                      suffixIcon: HideyImage(
                        'EyeSlash',
                        both: 24.h,
                        onTap: () {
                          showPass2 = !showPass2;
                          setState(() {});
                        },
                        color: AppColors.primaryColor,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        } else if (value != password.text) {
                          return "Passwords are different";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 44.h),
                    GeneralButton(
                      text: 'Confirm',
                      onPressed: () async {
                        autoValidate = true;
                        setState(() {});
                        if (formKey.currentState!.validate()) {
                          Utils.offKeyboard();
                          Map<String, dynamic> userData = {
                            'Email': widget.email,
                            "Code": pin,
                            'Password': password.text,
                          };

                          model.resetPassword(userData);
                        }
                      },
                      loading: model.busy,
                      primColor: AppColors.primaryColor,
                      textColor: const Color(0xffFFFFFF),
                      borderColor: AppColors.primaryColor,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
