import 'package:flutter_svg/svg.dart';
import 'package:mms_app/views/widgets/svg_button.dart';

import '__exports.dart';

class ChatField extends StatelessWidget {
  const ChatField({
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
    this.minLines,
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
  final double? minLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56.h,
            child: TextField(
              autofocus: true,
              keyboardType: typeOfInput,
              obscureText: obscureTexts,
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
                hintStyle: GoogleFonts.inter(
                  color: AppColors.black.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
                prefixIcon: Transform.scale(
                  scale: 0.5,
                  child: SvgPicture.asset(
                    'assets/icons/smiley.svg',
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 1,
                      child: SvgPicture.asset(
                        'assets/icons/paperclip.svg',
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    16.horizontalSpace,
                    Transform.scale(
                      scale: 1,
                      child: SvgPicture.asset(
                        'assets/icons/camera_text_field.svg',
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    16.horizontalSpace,
                  ],
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.lightGrey, width: 1),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey, width: 2),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.lightGrey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                ),
                hintText: hintMessage,
              ),
            ),
          ),
        ),
        8.horizontalSpace,
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightGrey,
          ),
          child: SVGButton(
            path: 'assets/icons/microphone.svg',
            onTap: onTapSuffix,
          ),
        ),
      ],
    );
  }
}
