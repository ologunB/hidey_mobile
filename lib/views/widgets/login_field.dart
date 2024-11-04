import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField(
      {Key? key,
      required this.hintMessage,
      this.validator,
      this.typeOfInput,
      this.obscureTexts = false,
      this.autoFocus = false,
      this.prefixIcon,
      this.suffixIcon,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.maxLength})
      : super(key: key);

  final String hintMessage;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextInputType? typeOfInput;
  final bool obscureTexts;
  final bool autoFocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: typeOfInput,
      obscureText: obscureTexts,
      validator: validator,
      autofocus: autoFocus,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: 1,
      style: GoogleFonts.inter(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.w),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff1A1A1A), width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        hintText: hintMessage,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: AppColors.black.withOpacity(.3),
        ),
      ),
    );
  }
}
