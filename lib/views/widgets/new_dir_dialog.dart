import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/models/directory_model.dart';
import '../../core/view_models/directory_vm.dart';
import '../user/directory/directory_details_view.dart';
import 'base_view.dart';
import 'login_field.dart';

class NewDirDialog extends StatefulWidget {
  const NewDirDialog({Key? key, this.renameDir, this.parentDir, this.openNew})
      : super(key: key);

  final DirectoryModel? renameDir;
  final DirectoryModel? parentDir;
  final bool? openNew;
  @override
  State<NewDirDialog> createState() => _NewDirDialogState();
}

class _NewDirDialogState extends State<NewDirDialog> {
  TextEditingController _controller = TextEditingController();
  @override
  initState() {
    super.initState();
    if (widget.renameDir != null) {
      _controller.text = widget.renameDir!.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.renameDir?.directoryID == null ? 'Directory' : 'File';
    return BaseView<DirectoryViewModel>(
      builder: (_, model, __) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
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
                widget.renameDir != null ? 'Rename $type' : 'New $type',
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 16.h),
              LoginFormField(
                controller: _controller,
                autoFocus: true,
                maxLength: 255,
                hintMessage: 'Untitled Directory',
                typeOfInput: TextInputType.text,
                onChanged: (a) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the directory name';
                  } else {
                    model.callError = null;
                  }
                  return null;
                },
              ),
              if (model.callError != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: RegularText(
                    model.callError!,
                    color: AppColors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                            if (_controller.text.isEmpty) {
                              model.callError = 'Name is required';
                              setState(() {});
                              return;
                            }
                            String? id =
                                widget.renameDir?.id ?? widget.parentDir?.id;
                            if (id?.isEmpty ?? true)
                              id = AppCache.getUser()?.rootId;
                            Map<String, dynamic> data = {
                              'Name': _controller.text,
                              'ParentID': id
                            };
                            if (widget.renameDir?.directoryID != null) {
                              bool val = await model.renameFile(
                                id!,
                                _controller.text,
                              );
                              if (val) {
                                Navigator.pop(context);
                              }
                            } else if (widget.renameDir == null) {
                              bool val = await model.createDir(data);
                              if (val) {
                                Navigator.pop(context);
                                if (widget.openNew == true) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          DirectoryDetailsView(
                                              dir: widget.parentDir!),
                                    ),
                                  );
                                }
                              }
                            } else {
                              bool val = await model.renameDir(data);
                              if (val) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: RegularText(
                            'Submit',
                            color: AppColors.black,
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
