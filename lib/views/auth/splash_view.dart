import 'package:flutter/material.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/views/widgets/custom_button.dart';

import '../../core/navigation/navigator.dart';
import '../widgets/text_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    setState(() {});
    if (AppCache.getToken() != null) {
      Future.delayed(Duration(seconds: 1), () {
        AppNavigator.navigateToAndReplace(MainLayoutRoute);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(
              top: AppCache.getToken() != null ? 5 : 200.h,
              left: 24.w,
              right: 24.w),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/shield_logo.png',
                    height: 35.h, width: 35.w),
                RegularText(
                  'Hidey',
                  color: const Color(0xffFFFFFF),
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (AppCache.getToken() == null) ...[
              SizedBox(height: 300.h),
              GeneralButton(
                text: 'Create Account',
                onPressed: () {
                  AppNavigator.navigateTo(SignUpRoute);
                },
                primColor: const Color(0xffFFFFFF),
                borderColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
              ),
              SizedBox(height: 24.h),
              GeneralButton(
                text: 'Log In',
                onPressed: () {
                  AppNavigator.navigateTo(LoginRoute);
                },
                primColor: AppColors.primaryColor,
                borderColor: const Color(0xffFFFFFF),
                textColor: const Color(0xffFFFFFF),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
