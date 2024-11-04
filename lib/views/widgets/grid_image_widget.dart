import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mms_app/views/widgets/colors.dart';

class FourImageGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390.h,
      width: 380.w,
      color: AppColors.white,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: [
          _buildImageContainer('assets/images/lockedImage.png'),
          _buildImageContainer('assets/images/lockedImage.png'),
          _buildImageContainer('assets/images/lockedImage.png'),
          _buildImageContainer('assets/images/lockedImage.png'),
        ],
      ),
    );
  }

  Widget _buildImageContainer(String imagePath) {
    return ClipRRect(
      // borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(16),
      //     topRight: Radius.circular(16),
      //     bottomLeft: Radius.circular(16)),
      child: Container(
        color: AppColors.lightGrey,
        child: Center(
          child: Image.asset(
            height: 64.h,
            width: 64.w,
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
