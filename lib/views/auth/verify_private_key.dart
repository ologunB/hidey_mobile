import 'package:flutter/material.dart';

import '../../core/models/user_model.dart';
import '../../core/view_models/auth_vm.dart';
import '../widgets/back_button.dart';
import '../widgets/base_view.dart';
import '../widgets/custom_button.dart';
import '../widgets/login_field.dart';
import '../widgets/text_widgets.dart';
import '../widgets/utils.dart';

class VerifyPrivateKey extends StatefulWidget {
  VerifyPrivateKey(this.user);
  final UserModel user;
  @override
  State<VerifyPrivateKey> createState() => _VerifyPrivateKeyState();
}

class _VerifyPrivateKeyState extends State<VerifyPrivateKey> {
  TextEditingController email = TextEditingController(
      text: 'vhXzfOh3Vt3BFETE4PrgcqZwDaJ+MnfR2XQug3UWzXw=');
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
            'Verify Private key',
            color: AppColors.black,
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
              RegularText(
                'Enter Private key',
                fontSize: 16.sp,
                height: 19 / 16,
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 10.h),
              LoginFormField(
                controller: email,
                hintMessage: 'Private key',
                validator: (a) {
                  return Utils.isValidName(a, 'Private Key', 10);
                },
                typeOfInput: TextInputType.text,
                onChanged: (a) {
                  setState(() {});
                },
              ),
              SizedBox(height: 44.h),
              GeneralButton(
                text: 'Verify',
                onPressed: () async {
                  autoValidate = true;
                  setState(() {});
                  if (formKey.currentState!.validate()) {
                    model.completeLogin(widget.user, email.text);
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
