import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/custom_loader.dart';

import '../../../../core/apis/encryption_tool.dart';
import '../../../../core/models/directory_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/view_models/directory_vm.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/base_view.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_widgets.dart';
import 'people_with_access.dart';

class ShareFileScreen extends StatefulWidget {
  const ShareFileScreen({Key? key, required this.dirs}) : super(key: key);

  final List<DirectoryModel> dirs;
  @override
  State<ShareFileScreen> createState() => _ShareFileScreenState();
}

class _ShareFileScreenState extends State<ShareFileScreen> {
  TextEditingController controller = TextEditingController();
  List<User> selected = [];
  List<User> allUsers = [];

  @override
  Widget build(BuildContext context) {
    bool isFile = widget.dirs.first.parentID == null;

    return BaseView<DirectoryViewModel>(
      builder: (_, model, __) => Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF5F5F5),
          leading: HideyBackButton(),
          centerTitle: true,
          title: RegularText(
            'Share ${isFile ? 'File' : 'Directory'}',
            color: const Color(0xff1A1A1A),
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(24.h),
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(color: AppColors.gray)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                      runSpacing: 3,
                      spacing: 3,
                      children: selected
                          .map((e) => Container(
                                padding: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.h),
                                    border: Border.all(color: AppColors.gray)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                        radius: 12.h,
                                        backgroundColor: AppColors.gray),
                                    SizedBox(width: 5.h),
                                    RegularText(
                                      e.email!,
                                      color: AppColors.gray,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(width: 5.h),
                                    InkWell(
                                        onTap: () {
                                          selected.removeWhere((element) =>
                                              element.email == e.email);
                                          allUsers.add(e);
                                          sortAll();
                                        },
                                        child: Icon(Icons.cancel))
                                  ],
                                ),
                              ))
                          .toList()),
                  CupertinoTextField(
                    decoration: BoxDecoration(color: Colors.transparent),
                    controller: controller,
                    placeholder: 'Enter user email',
                    onChanged: (a) {
                      getNewItems(model, a);
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 30.h),
            if (controller.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 22.h),
                child: RegularText(
                  'Found ${allUsers.length} users',
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            controller.text.isEmpty
                ? PeopleWithAccess(dir: widget.dirs.first)
                : model.busy
                    ? CustomLoader()
                    : ListView.builder(
                        itemCount: allUsers.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (c, i) {
                          User u = allUsers[i];
                          return InkWell(
                            onTap: () {
                              if (!selected
                                  .any((element) => element.email == u.email)) {
                                selected.add(u);
                                allUsers.removeWhere(
                                    (element) => element.email == u.email);
                              }
                              sortAll();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.gray),
                                  SizedBox(width: 8.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RegularText(
                                        '${u.firstName} ${u.lastName}',
                                        color: AppColors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(height: 4.h),
                                      RegularText(
                                        '${u.email}',
                                        color: AppColors.gray,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
            SizedBox(height: 60.h),
            BaseView<DirectoryViewModel>(
              builder: (_, addModel, __) => GeneralButton(
                text: 'Share',
                onPressed: () async {
                  if (selected.isEmpty) return;
                  List<Map<String, dynamic>> files = [];

                  if (isFile) {
                    for (User user in selected) {
                      for (DirectoryModel dir in widget.dirs) {
                        String token = EncryptionTool.shareData(
                            dir.privileges!.first.decryptionKey!,
                            user.publicKey!);
                        Map<String, dynamic> data = {
                          "recipientId": user.id,
                          "fileId": dir.id,
                          "permission": {"read": true, "write": false},
                          "decryptionKey": token
                        };
                        files.add(data);
                      }
                    }
                  } else {
                    for (DirectoryModel dir in widget.dirs) {
                      List<KeyAndId>? gottenIdAndKeys =
                          await addModel.getAllDirKeys(dir.id!);

                      if (gottenIdAndKeys == null) return;
                      for (User user in selected) {
                        // get list of files for the directory

                        Map<String, String> convertedIdAndKeys = {};
                        for (KeyAndId gottenIdAndKey in gottenIdAndKeys) {
                          String t = EncryptionTool.shareData(
                              gottenIdAndKey.key!, user.publicKey!);
                          convertedIdAndKeys[gottenIdAndKey.id!] = t;
                        }

                        Map<String, dynamic> data = {
                          "recipientId": user.id,
                          "directoryId": dir.id,
                          "permission": {"read": true, "write": false},
                          "fileDecryptionKeys": convertedIdAndKeys
                        };
                        files.add(data);
                      }
                    }
                  }

                  print(files.isEmpty);

                  addModel.addPrivilege(files, isFile);
                },
                loading: addModel.busy,
                primColor: AppColors.primaryColor,
                textColor: Colors.white,
                borderColor: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 30.h),
            GeneralButton(
              text: 'Copy Link',
              onPressed: () {},
              primColor: Color(0xffEFEFEF),
              textColor: AppColors.primaryColor,
              borderColor: Color(0xffEFEFEF),
            ),
          ],
        ),
      ),
    );
  }

  void getNewItems(DirectoryViewModel model, String a) async {
    try {
      List<User> all = await model.allUsers(context) ?? [];
      all.removeWhere((element) => element.publicKey!.isEmpty);

      all.removeWhere(
          (element) => selected.any((e) => e.email == element.email));
      allUsers = all;
      sortAll();
    } catch (e) {
      print(e);
    }
  }

  void sortAll() {
    selected.sort((a, b) => a.firstName!.compareTo(b.firstName!));
    allUsers.sort((a, b) => a.firstName!.compareTo(b.firstName!));
    setState(() {});
  }
}
