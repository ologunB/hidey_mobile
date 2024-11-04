import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/models/task_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({Key? key, required this.zTask}) : super(key: key);

  final ZTask zTask;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.h),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            width: 2.h,
            color: AppColors.gray.withOpacity(.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              zTask.message ?? 'no-name',
              color: AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 4.h),
            RegularText(
              '${zTask.progress! ~/ zTask.total!}% Uploading',
              color: AppColors.gray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
