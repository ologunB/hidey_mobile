import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class FilterSwitch extends StatelessWidget {
  const FilterSwitch({
    super.key,
    required this.onTapFolders,
    required this.onTapFiles,
    required this.selectedType,
    required this.firstTitle,
    required this.secondTitle,
  });
  final Function()? onTapFolders;
  final Function()? onTapFiles;
  final int selectedType;
  final String firstTitle;
  final String secondTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTapFolders,
            borderRadius: BorderRadius.circular(30.h),
            child: Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: selectedType == 1 ? null : AppColors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: RegularText(
                firstTitle,
                color: selectedType == 1 ? AppColors.gray : AppColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          InkWell(
            onTap: onTapFiles,
            borderRadius: BorderRadius.circular(30.h),
            child: Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: selectedType == 0 ? null : AppColors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: RegularText(
                secondTitle,
                color: selectedType == 0 ? AppColors.gray : AppColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
