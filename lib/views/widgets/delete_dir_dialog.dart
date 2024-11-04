import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/models/directory_model.dart';
import '../../core/view_models/directory_vm.dart';
import 'base_view.dart';

class DeleteDirDialog extends StatefulWidget {
  const DeleteDirDialog({Key? key, required this.dir, required this.addNew})
      : super(key: key);
  final DirectoryModel dir;
  final bool addNew;
  @override
  State<DeleteDirDialog> createState() => _DeleteDirDialogState();
}

class _DeleteDirDialogState extends State<DeleteDirDialog> {
  @override
  Widget build(BuildContext context) {
    String type = widget.dir.directoryID == null ? 'Directory' : 'File';

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
                'Delete $type',
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 16.h),
              RegularText(
                'Are you sure you want to delete this $type?',
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
                            bool val;
                            if (widget.dir.directoryID == null) {
                              val = await model.deleteOneDir(widget.dir);
                            } else {
                              val = await model.deleteFile(widget.dir);
                            }
                            if (val == true) {
                              Navigator.pop(context);
                              if (widget.addNew) Navigator.pop(context);
                            }
                            setState(() {});
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
