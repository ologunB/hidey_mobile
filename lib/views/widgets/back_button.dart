import 'package:flutter/material.dart';

import '../../core/navigation/navigator.dart';
import 'text_widgets.dart';

class HideyBackButton extends StatelessWidget {
  const HideyBackButton({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          onPressed: onPressed ?? () => AppNavigator.doPop(),
        ),
      ],
    );
  }
}
