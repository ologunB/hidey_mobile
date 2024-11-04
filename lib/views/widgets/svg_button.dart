import 'package:flutter_svg/svg.dart';

import '__exports.dart';

class SVGButton extends StatelessWidget {
  const SVGButton({
    super.key,
    required this.path,
    this.onTap,
    this.width,
    this.color,
    this.height,
  });
  final String path;
  final void Function()? onTap;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        path,
        height: height,
        width: width,
        // ignore: deprecated_member_use
        color: color,
      ),
    );
  }
}

class SVGWidget extends StatelessWidget {
  const SVGWidget(
    this.path, {
    super.key,
    this.width,
    this.color,
    this.height,
  });
  final String path;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/$path.svg",
      height: height,
      width: width,
      // ignore: deprecated_member_use
      color: color,
    );
  }
}
