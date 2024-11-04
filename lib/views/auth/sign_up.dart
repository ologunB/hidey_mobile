import 'package:flutter/material.dart';
import 'package:mms_app/views/auth/create_password.dart';
import 'package:mms_app/views/widgets/back_button.dart';
import '../widgets/base_view.dart';
import '../widgets/check_widget.dart';
import '../widgets/text_widgets.dart';
import '../../core/navigation/navigator.dart';
import 'package:mms_app/core/view_models/auth_vm.dart';
import 'package:mms_app/views/widgets/custom_button.dart';
import '../widgets/utils.dart';
import '../widgets/login_field.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();

  bool autoValidate = false;

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
          bottomNavigationBar: SafeArea(
            child: GestureDetector(
              onTap: () {
                AppNavigator.navigateTo(LoginRoute);
              },
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RegularText(
                      'Have an account already? ',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                    RegularText(
                      'Log In',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xffF5F5F5),
            leading: HideyBackButton(),
            centerTitle: true,
            title: RegularText(
              'Create account',
              color: AppColors.gray,
              fontSize: 24.sp,
              height: 29 / 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            children: [
              RegularText(
                'First name',
                fontSize: 16.sp,
                height: 19 / 16,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              LoginFormField(
                hintMessage: 'Darlene',
                controller: firstName,
                validator: (a) {
                  return Utils.isValidName(a, '"First name"', 2);
                },
                onChanged: (a) {
                  setState(() {});
                },
                suffixIcon: Utils.isValidName(firstName.text, '', 2) == null
                    ? CheckWidget()
                    : null,
              ),
              SizedBox(height: 20.h),
              RegularText(
                'Last name',
                fontSize: 16.sp,
                height: 19 / 16,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              LoginFormField(
                hintMessage: 'Robertson',
                controller: lastName,
                validator: (a) {
                  return Utils.isValidName(a, '"Last name"', 2);
                },
                onChanged: (a) {
                  setState(() {});
                },
                suffixIcon: Utils.isValidName(lastName.text, '', 2) == null
                    ? CheckWidget()
                    : null,
              ),
              SizedBox(height: 20.h),
              RegularText(
                'Email address',
                fontSize: 16.sp,
                height: 19 / 16,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              LoginFormField(
                controller: email,
                hintMessage: 'Darlenerobert@gmail.com',
                typeOfInput: TextInputType.emailAddress,
                validator: (a) {
                  return Utils.validateEmail(a!);
                },
                onChanged: (a) {
                  setState(() {});
                },
                suffixIcon: Utils.validateEmail(email.text) == null
                    ? CheckWidget()
                    : null,
              ),
              SizedBox(height: 20.h),
              RegularText(
                'Username',
                fontSize: 16.sp,
                height: 19 / 16,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              LoginFormField(
                controller: username,
                hintMessage: "Robert_22",
                validator: (a) {
                  return Utils.isValidName(a, 'Username', 2);
                },
                onChanged: (a) {
                  setState(() {});
                },
                suffixIcon: Utils.isValidName(username.text, '', 2) == null
                    ? CheckWidget()
                    : null,
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 60.h),
              GeneralButton(
                text: 'Continue',
                onPressed: model.busy
                    ? null
                    : () {
                        autoValidate = true;
                        setState(() {});
                        if (formKey.currentState!.validate()) {
                          Utils.offKeyboard();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePassword(
                                firstName: firstName.text,
                                lastName: lastName.text,
                                email: email.text,
                                userName: username.text,
                              ),
                            ),
                          );
                          print("sent data");
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
}
