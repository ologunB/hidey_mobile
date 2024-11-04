import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class PinCode extends StatefulWidget {
  const PinCode({Key? key, required this.onChanged}) : super(key: key);

  final Function(String) onChanged;
  @override
  State<PinCode> createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: PinCodeTextField(
          length: 6,
          obscureText: false,
          autoFocus: true,
          cursorColor: AppColors.primaryColor,
          animationType: AnimationType.slide,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            fieldHeight: 50.h,
            activeColor: AppColors.primaryColor,
            selectedColor: Colors.black,
            inactiveColor: Colors.black,
            fieldWidth: 40.h,
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: false,
          onChanged: widget.onChanged,
          appContext: context,
        ),
      ),
    );
  }
}
