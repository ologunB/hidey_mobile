import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../widgets/text_widgets.dart';

export 'utils.dart';

void showSnackBar(
  BuildContext context,
  String? title,
  String? msg, {
  int duration = 3,
  Color color = AppColors.primaryColor,
  TextAlign align = TextAlign.start,
}) {
  final Flushbar<void> flushBar = Flushbar<void>(
    titleText: title == null
        ? null
        : RegularText(
            title,
            textAlign: align,
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
    messageText: msg == null
        ? null
        : RegularText(
            msg,
            fontSize: 14.sp,
            color: Colors.white,
            textAlign: align,
            fontWeight: FontWeight.w400,
          ),
    margin: EdgeInsets.all(6.h),
    borderRadius: BorderRadius.circular(12),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration),
    backgroundColor: title == 'Error' ? AppColors.red : color,
  );

  if (!flushBar.isShowing()) {
    flushBar.show(context);
  }
}
