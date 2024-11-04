import 'package:flutter/material.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/view_models/directory_vm.dart';
import '../../../widgets/base_view.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/text_widgets.dart';

class PeopleWithAccess extends StatefulWidget {
  const PeopleWithAccess({Key? key, required this.dir}) : super(key: key);

  final DirectoryModel dir;
  @override
  State<PeopleWithAccess> createState() => _PeopleWithAccessState();
}

class _PeopleWithAccessState extends State<PeopleWithAccess> {
  @override
  Widget build(BuildContext context) {
    bool isFile = widget.dir.parentID == null;
    return BaseView<DirectoryViewModel>(
        onModelReady: (m) => m.getUserDataList(widget.dir, context),
        builder: (_, model, __) => model.busy
            ? Container(
                height: 100.h,
                alignment: Alignment.center,
                child: CustomLoader(),
              )
            : model.peopleAccess == null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RegularText(
                          model.callError ?? '',
                          color: AppColors.red,
                          textAlign: TextAlign.center,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 150.h),
                          child: GeneralButton(
                            text: 'Retry',
                            onPressed: () {
                              model.getUserDataList(widget.dir, context);
                            },
                            height: 40,
                            primColor: AppColors.white,
                            textColor: AppColors.primaryColor,
                            borderColor: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : model.peopleAccess!.isEmpty
                    ? RegularText(
                        'The ${isFile ? 'File' : 'Directory'} has not been shared with anyone',
                        color: AppColors.black,
                        textAlign: TextAlign.center,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 22.h),
                            child: RegularText(
                              'People with access',
                              color: AppColors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListView.builder(
                            itemCount: model.peopleAccess!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (c, i) {
                              User user = model.peopleAccess![i];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.gray,
                                    ),
                                    SizedBox(width: 8.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RegularText(
                                          '${user.firstName} ${user.lastName}',
                                          color: AppColors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 4.h),
                                        RegularText(
                                          '${user.email}',
                                          color: AppColors.gray,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    if (user.email == AppCache.getUser()?.email)
                                      RegularText(
                                        'Owner',
                                        color: AppColors.gray,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ));
  }
}
