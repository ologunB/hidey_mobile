import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/views/widgets/custom_image.dart';
import 'package:mms_app/views/widgets/svg_button.dart';

import 'colors.dart';

class SearchFormField extends StatelessWidget {
  const SearchFormField({
    Key? key,
    required this.hintMessage,
    this.validator,
    this.typeOfInput,
    this.obscureTexts = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.autoFocus,
  }) : super(key: key);

  final String hintMessage;
  final String? Function(String?)? validator;
  final TextInputType? typeOfInput;
  final bool obscureTexts;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus ?? false,
      keyboardType: typeOfInput,
      obscureText: obscureTexts,
      validator: validator,
      focusNode: focusNode,
      style: GoogleFonts.inter(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.w),
        prefixIcon: HideyImage(
          'search',
          both: 24.h,
          color: AppColors.gray,
        ),
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: suffixIcon,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(50.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey, width: 2),
          borderRadius: BorderRadius.circular(50.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
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

class CommentFormField extends StatelessWidget {
  const CommentFormField({
    Key? key,
    required this.hintMessage,
    this.validator,
    this.typeOfInput,
    this.obscureTexts = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.onTapSuffix,
  }) : super(key: key);

  final String hintMessage;
  final String? Function(String?)? validator;
  final TextInputType? typeOfInput;
  final bool obscureTexts;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function()? onTapSuffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
      color: AppColors.lightGrey,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56.h,
              child: TextFormField(
                autofocus: true,
                keyboardType: typeOfInput,
                obscureText: obscureTexts,
                validator: validator,
                focusNode: focusNode,
                cursorColor: AppColors.black,
                cursorHeight: 10,
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 16.sp,
                ),
                controller: controller,
                decoration: InputDecoration(
                  isCollapsed: true,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.sp, horizontal: 16.w),
                  prefixIcon: Transform.scale(
                    scale: 0.5,
                    child: SvgPicture.asset(
                      'assets/icons/smiley.svg',
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.lightGrey, width: 1),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.lightGrey, width: 2),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.lightGrey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  ),
                  hintText: hintMessage,
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.black.withOpacity(.3),
                  ),
                ),
              ),
            ),
          ),
          8.horizontalSpace,
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: SVGButton(
              path: 'assets/icons/field_suffix.svg',
              onTap: onTapSuffix,
            ),
          ),
        ],
      ),
    );
  }
}
