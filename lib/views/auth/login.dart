import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/back_button.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/navigation/navigator.dart';
import '../../core/view_models/auth_vm.dart';
import '../widgets/base_view.dart';
import '../widgets/check_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/login_field.dart';
import '../widgets/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email =
      TextEditingController(text: 'lajuda@tutuapp.bid');
  TextEditingController password = TextEditingController(text: 'Topetope@17');
  bool autoValidate = false;

  @override
  initState() {
    Future.delayed(Duration.zero, () => setState(() {}));
    super.initState();
  }

  bool obscureText = true;

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
              centerTitle: true,
              title: RegularText(
                'Log In',
                color: AppColors.black,
                fontSize: 24.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              leading: !AppNavigator.canPop ? null : HideyBackButton(),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/shield_logo.png',
                      height: 35.h,
                      width: 35.h,
                      color: AppColors.primaryColor,
                    ),
                    RegularText(
                      'Hidey',
                      color: AppColors.primaryColor,
                      fontSize: 36.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 54.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      'Email address',
                      fontSize: 16.sp,
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 4.h),
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
                    SizedBox(height: 24.h),
                    RegularText(
                      'Password',
                      fontSize: 16.sp,
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 4.h),
                    LoginFormField(
                        hintMessage: 'Password',
                        obscureTexts: obscureText,
                        controller: password,
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                obscureText = !obscureText;
                                setState(() {});
                              },
                              child: Icon(
                                !obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.gray,
                                size: 20.h,
                              ),
                            ),
                          ],
                        ),
                        validator: Utils.isValidPassword),
                    SizedBox(
                      height: 6.h,
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.navigateTo(ForgotPasswordRoute),
                      child: RegularText(
                        'Forgot password?',
                        fontSize: 16.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    GeneralButton(
                        text: 'Log In',
                        onPressed: model.busy
                            ? null
                            : () {
                                autoValidate = true;
                                setState(() {});
                                if (formKey.currentState!.validate()) {
                                  Utils.offKeyboard();
                                  Map<String, dynamic> userData = {
                                    'Email': email.text,
                                    'Password': password.text,
                                  };

                                  model.login(userData);
                                }
                              },
                        loading: model.busy,
                        primColor: AppColors.primaryColor,
                        textColor: const Color(0xffFFFFFF),
                        borderColor: AppColors.primaryColor),
                    SizedBox(
                      height: 200.h,
                    ),
                    Center(
                      child: Wrap(
                        children: [
                          RegularText(
                            'Don\'t have an account?',
                            fontSize: 16.sp,
                            color: const Color(0xff1A1A1A),
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () => AppNavigator.navigateTo(SignUpRoute),
                            child: RegularText(
                              'Sign Up',
                              fontSize: 16.sp,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
