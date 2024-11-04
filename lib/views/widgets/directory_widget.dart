import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../user/directory/directory_details_view.dart';
import '../user/directory/file_details_view.dart';
import 'custom_image.dart';
import 'dir_more_options.dart';
import 'file_more_options.dart';

class DirectoryWidget extends StatelessWidget {
  const DirectoryWidget({Key? key, this.addMargin = true, this.dir})
      : super(key: key);

  final bool addMargin;
  final DirectoryModel? dir;
  @override
  Widget build(BuildContext context) {
    bool isFile = dir?.parentID == null;
    return HomeWrap(
      isFile: isFile,
      dir: dir!,
      child: Container(
        padding: addMargin ? EdgeInsets.only(right: 16.h) : null,
        child: InkWell(
          onTap: () {
            if (isFile) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FileDetailsScreen(dir: dir!),
                ),
              );
              return;
            }
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => DirectoryDetailsView(dir: dir!),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: HideyImage(
                        Utils.getImageType(dir),
                        both: 24.h,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RegularText(
                              dir?.name ?? 'no-name',
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                RegularText(
                                  '25GB',
                                  color: AppColors.gray,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                Spacer(),
                                RegularText(
                                  '50GB',
                                  color: AppColors.gray,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: LinearProgressIndicator(
                                minHeight: 2.h,
                                value: .5,
                                backgroundColor: AppColors.white,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RegularText(
                            'Folder',
                            color: AppColors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: 4.h),
                          RegularText(
                            '100GB',
                            color: AppColors.gray,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: RegularText(
                        'Upload',
                        color: AppColors.primaryColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeWrap extends StatelessWidget {
  const HomeWrap(
      {Key? key, required this.child, required this.isFile, required this.dir})
      : super(key: key);

  final Widget child;
  final bool isFile;
  final DirectoryModel dir;
  @override
  Widget build(BuildContext context) {
    return isFile
        ? FileMoreOptions(child: child, dir: dir, allowTap: false)
        : DirMoreOptions(child: child, dir: dir, allowTap: false);
  }
}
