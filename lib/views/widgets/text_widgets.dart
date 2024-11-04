import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
export 'package:google_fonts/google_fonts.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'colors.dart';

class RegularText extends StatelessWidget {
  const RegularText(
    this.text, {
    Key? key,
    this.color,
    this.letterSpacing,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontWeight,
    this.blur = false,
    this.fontSize = 14,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: GoogleFonts.inter(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}

class RobotoText extends StatelessWidget {
  const RobotoText(
    this.text, {
    Key? key,
    this.color,
    this.letterSpacing,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontWeight,
    this.blur = false,
    this.fontSize = 14,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: GoogleFonts.roboto(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}

class HeeboText extends StatelessWidget {
  const HeeboText(
    this.text, {
    Key? key,
    this.color,
    this.letterSpacing,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontWeight,
    this.blur = false,
    this.fontSize = 14,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: GoogleFonts.heebo(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
