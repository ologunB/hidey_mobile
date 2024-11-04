import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../core/models/directory_model.dart';
import '../user/directory/directory_details_view.dart';
import '../user/directory/file_details_view.dart';
import 'custom_image.dart';
import 'dir_more_options.dart';
import 'file_more_options.dart';

class DirectoryTile extends StatelessWidget {
  const DirectoryTile(
      {Key? key, required this.dir, this.onLongPress, this.isSelected})
      : super(key: key);

  final DirectoryModel dir;
  final Function()? onLongPress;
  final bool? isSelected;
  @override
  Widget build(BuildContext context) {
    bool isFile = dir.parentID == null;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: HideyImage(
                    Utils.getImageType(dir),
                    both: 24.h,
                    color: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegularText(
                          dir.name ?? 'no-name',
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        RegularText(
                          Utils.getByteSize(dir.size ?? 0),
                          color: AppColors.gray,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
