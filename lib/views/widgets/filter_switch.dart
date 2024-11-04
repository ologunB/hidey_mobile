import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class FilterArrow extends StatelessWidget {
  const FilterArrow({
    super.key,
    required this.onTapSwitch,
  });
  final void Function()? onTapSwitch;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapSwitch,
      borderRadius: BorderRadius.circular(30.h),
      child: Container(
        padding: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(
          Icons.filter_list_rounded,
          color: AppColors.black,
          size: 28.h,
        ),
      ),
    );
  }
}
