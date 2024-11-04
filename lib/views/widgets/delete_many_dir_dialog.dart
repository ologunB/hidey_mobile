import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/view_models/directory_vm.dart';
import 'base_view.dart';

class DeleteManyDirDialog extends StatelessWidget {
  const DeleteManyDirDialog(
      {Key? key,
      required this.addNew,
      required this.dirIds,
      required this.fileIds,
      required this.parentId,
      required this.onSuccess})
      : super(key: key);
  final bool addNew;
  final List<String> dirIds;
  final List<String> fileIds;
  final String parentId;
  final Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return BaseView<DirectoryViewModel>(
      builder: (_, model, __) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width - 48.h,
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegularText(
                'Delete Files/Directories',
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 16.h),
              RegularText(
                'Are you sure you want to delete all?',
                color: AppColors.gray,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: RegularText(
                      'Cancel',
                      color: AppColors.gray,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  model.busy
                      ? Padding(
                          padding: EdgeInsets.only(left: 55.h),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor),
                            ),
                            height: 15.h,
                            width: 15.h,
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            bool val = await model.deleteManyDir(
                                dirIds, fileIds, parentId);

                            if (val == true) {
                              onSuccess();
                              Navigator.pop(context);
                              if (addNew) Navigator.pop(context);
                            }
                          },
                          child: RegularText(
                            'Delete',
                            color: AppColors.red,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
