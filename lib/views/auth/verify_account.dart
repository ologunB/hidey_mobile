import 'package:flutter/material.dart';

import '../../core/view_models/auth_vm.dart';
import '../widgets/back_button.dart';
import '../widgets/base_view.dart';
import '../widgets/custom_button.dart';
import '../widgets/pincode.dart';
import '../widgets/text_widgets.dart';
import '../widgets/utils.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  String pin = '';
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (_, AuthViewModel model, __) => Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF5F5F5),
          leading: HideyBackButton(),
          title: RegularText(
            'Verification',
            color: const Color(0xff000000),
            fontSize: 24.h,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
          children: [
            RegularText(
              'We sent you a code!',
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              color: const Color(0xff1A1A1A),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: RegularText(
                'Enter the 6 digit code sent to your email address for verification',
                fontSize: 14.h,
                color: AppColors.gray,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            PinCode(onChanged: (a) => setState(() => pin = a)),
            SizedBox(height: 44.h),
            GeneralButton(
              text: 'Verify',
              onPressed: pin.length != 6
                  ? null
                  : () {
                      Utils.offKeyboard();
                      model.verify({'Email': widget.email, 'Code': pin});
                    },
              loading: model.busy,
              primColor: AppColors.primaryColor,
              textColor: const Color(0xffFFFFFF),
              borderColor: AppColors.primaryColor,
            ),
            SizedBox(
              height: 54.h,
            ),
            Center(
              child: Wrap(
                children: [
                  RegularText(
                    'Didn\'t receive code?',
                    fontSize: 14.sp,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  BaseView<AuthViewModel>(
                      builder: (_, AuthViewModel m, __) => m.busy
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.h),
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.h,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor),
                                ),
                                height: 15.h,
                                width: 15.h,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                m.generateResetPassword(
                                  {'email': widget.email},
                                  navigate: false,
                                );
                              },
                              child: RegularText(
                                'Resend code',
                                fontSize: 14.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
