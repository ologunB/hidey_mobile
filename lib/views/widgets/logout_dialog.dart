import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/navigation/navigator.dart';
import '../../core/storage/local_storage.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width - 48.h,
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              'Logout',
              color: AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 16.h),
            RegularText(
              'Are you sure you want to logout of the app?',
              color: AppColors.gray,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: RegularText(
                    'Cancel',
                    color: AppColors.gray,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await AppCache.clear();
                    AppNavigator.navigateToAndClear(SplashRoute);
                  },
                  child: RegularText(
                    'Confirm',
                    color: AppColors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
