import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../user/directory/directory_details_view.dart';
import '../user/directory/file_details_view.dart';
import 'custom_image.dart';
import 'dir_more_options.dart';
import 'file_more_options.dart';

class DirectoryGrid extends StatelessWidget {
  const DirectoryGrid(
      {Key? key, required this.dir, this.onLongPress, this.isSelected})
      : super(key: key);

  final DirectoryModel dir;
  final Function()? onLongPress;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    bool isFile = dir.parentID == null;
    return GestureDetector(
      onTap: isSelected != null
          ? onLongPress
          : () {
              if (isFile) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FileDetailsScreen(dir: dir),
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => DirectoryDetailsView(dir: dir),
                ),
              );
            },
      onLongPress: onLongPress,
      child: Opacity(
        opacity: isSelected == false ? .5 : 1,
        child: Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              width: 1.h,
              color: AppColors.gray.withOpacity(.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: HideyImage(
                      Utils.getImageType(dir),
                      both: 24.h,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Spacer(),
                  isSelected != null
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: isSelected!
                              ? Icon(
                                  Icons.check_box_rounded,
                                  color: AppColors.primaryColor,
                                  size: 24.h,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank_rounded,
                                  color: AppColors.primaryColor,
                                  size: 24.h,
                                ),
                        )
                      : isFile
                          ? FileMoreOptions(dir: dir)
                          : DirMoreOptions(dir: dir),
                ],
              ),
              SizedBox(height: 16.h),
              RegularText(
                dir.name ?? 'no-name',
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4.h),
              RegularText(
                timeago.format(DateTime.parse(dir.updatedAt ?? '2022-11-13')),
                color: AppColors.gray,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
