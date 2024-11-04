import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/navigator.dart';
import '../../core/utils/app_file_picker.dart';
import '../../core/view_models/directory_vm.dart';
import '../../core/view_models/video_vm.dart';
import 'base_view.dart';
import 'custom_image.dart';
import 'new_dir_dialog.dart';

class OptionDialog extends StatefulWidget {
  const OptionDialog({Key? key, this.dir}) : super(key: key);

  final DirectoryModel? dir;
  @override
  State<OptionDialog> createState() => _OptionDialogState();
}

class _OptionDialogState extends State<OptionDialog> {
  @override
  Widget build(BuildContext context) {
    return BaseView<DirectoryViewModel>(
      builder: (_, model, __) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width - 48.h,
          padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RegularText(
                'Create New',
                color: AppColors.black,
                fontSize: 36.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 48.h),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                shrinkWrap: true,
                children: [0, 1, 2]
                    .map((e) => InkWell(
                          onTap: () async {
                            String id = widget.dir?.directoryID ??
                                widget.dir?.id ??
                                'root';
                            Navigator.pop(context);
                            if (e == 0) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return NewDirDialog(parentDir: widget.dir);
                                },
                              );
                            } else if (e == 1) {
                              final File? result =
                                  await AppFilePicker.pickImage();
                              if (result != null) {
                                File file = File(result.path);
                                model.createFile(id, [file]);
                              }
                            } else if (e == 2) {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                File file = File(result.files.single.path!);

                                if (Utils.isVideoFile(file.path)) {
                                  print('object');

                                  lContext
                                      .read<VideoViewModel>()
                                      .createUploadSession(
                                        widget.dir!.id!,
                                        pick: false,
                                        path: file.path,
                                      );
                                } else {
                                  model.createFile(id, [file]);
                                }
                              } else {
                                // User canceled the picker
                              }
                            }
                          },
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HideyImage('op$e', both: 48.h),
                              SizedBox(height: 8.h),
                              RegularText(
                                ops[e],
                                color: AppColors.gray,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  BuildContext get lContext => AppNavigator.navKey.currentContext!;

  List<String> get ops => [
        'Directory',
        'Upload',
        'File',
      ];
}
