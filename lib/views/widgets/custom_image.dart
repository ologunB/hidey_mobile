import 'package:flutter/material.dart';

class HideyImage extends StatelessWidget {
  const HideyImage(this.a,
      {this.onTap, this.both = 40, this.width, this.height, this.color});

  final String a;
  final Function()? onTap;
  final double? both;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/$a.png',
                height: height ?? both,
                width: width ?? both,
                color: color,
                fit: BoxFit.contain,
              ),
            ],
          ),
        )
      ],
    );
  }
}
