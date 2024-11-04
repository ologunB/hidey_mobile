import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/custom_image.dart';

import '../../core/view_models/auth_vm.dart';
import '../widgets/back_button.dart';
import '../widgets/base_view.dart';
import '../widgets/check_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/login_field.dart';
import '../widgets/text_widgets.dart';
import '../widgets/utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (_, AuthViewModel model, __) => Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: RegularText(
            'Forgot password',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  RegularText(
                    'Enter your email to reset your account',
                    fontSize: 16.sp,
                    height: 19 / 16,
                    color: const Color(0xff1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 10.h),
                  LoginFormField(
                    controller: email,
                    hintMessage: 'Darlenerobert@gmail.com',
                    validator: Utils.validateEmail,
                    typeOfInput: TextInputType.emailAddress,
                    onChanged: (a) {
                      setState(() {});
                    },
                    suffixIcon: Utils.validateEmail(email.text) == null
                        ? CheckWidget()
                        : null,
                  ),
                  SizedBox(height: 44.h),
                  GeneralButton(
                    text: 'Reset',
                    onPressed: () async {
                      autoValidate = true;
                      setState(() {});
                      if (formKey.currentState!.validate()) {
                        Utils.offKeyboard();
                        Map<String, dynamic> userData = {'Email': email.text};

                        model.generateResetPassword(userData);
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
