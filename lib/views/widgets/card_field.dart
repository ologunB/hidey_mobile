import '__exports.dart';

class CardFormField extends StatelessWidget {
  const CardFormField({
    Key? key,
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
    this.maxLength,
    this.width,
  }) : super(key: key);

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
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 56.h,
      child: TextFormField(
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.w),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.darkGray.withOpacity(0.2), width: 1),
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
      ),
    );
  }
}
