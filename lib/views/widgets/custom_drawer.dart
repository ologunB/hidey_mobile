import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/views/user/home/profile.dart';
import 'package:mms_app/views/user/settings/settings_view.dart';
import 'package:mms_app/views/widgets/custom_image.dart';

import '../user/directory/share/flag_directory_view.dart';
import 'logout_dialog.dart';
import 'option_dialog.dart';
import 'text_widgets.dart';

class HideyDrawer extends StatefulWidget {
  const HideyDrawer({Key? key}) : super(key: key);

  @override
  State<HideyDrawer> createState() => _HideyDrawerState();
}

class _HideyDrawerState extends State<HideyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            bottom: false,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfileScreen(
                      isPersonalProfile: true,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(24.h),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: HideyImage('profile', both: 50.h),
                    ),
                    SizedBox(width: 8.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RegularText(
                            '${AppCache.getUser()?.firstName} ${AppCache.getUser()?.lastName}',
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 4.h),
                          RegularText(
                            '${AppCache.getUser()?.email}',
                            color: AppColors.gray,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.h),
                  onTap: () async {
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return OptionDialog();
                      },
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.h)),
                      border: Border.all(
                        width: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: RegularText(
                      'Create New',
                      color: AppColors.primaryColor,
                      fontSize: 16.sp,
                      height: 22 / 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListView.builder(
              itemCount: types.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: HideyImage('d$i', both: 24.h),
                  ),
                  minLeadingWidth: 0,
                  title: RegularText(types[i],
                      color: AppColors.black,
                      fontSize: 14.sp,
                      height: 22 / 18,
                      fontWeight: FontWeight.w500),
                  onTap: () async {
                    if (i == 5) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    } else if (i == 7) {
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return LogoutDialog();
                        },
                      );
                    } else if (i == 2) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => FlagDirectoryView(),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              }),
          Padding(
            padding: EdgeInsets.only(left: 30.h, bottom: 8.h, top: 16.h),
            child: RegularText(
              '25GB of 50GB',
              color: AppColors.gray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.h, right: 100.h, bottom: 24.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: LinearProgressIndicator(
                value: .5,
                minHeight: 5.h,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation(
                  AppColors.primaryColor,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.w, bottom: 30.h),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.h),
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.h)),
                      border: Border.all(
                        width: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: RegularText('Buy Storage',
                        color: AppColors.primaryColor,
                        fontSize: 16.sp,
                        height: 22 / 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  List<String> types = [
    'Directory',
    'Recent',
    'Shared',
    'Trash',
    'Starred',
    'Settings',
    'Activity',
    'Logout',
    'Storage',
  ];
}
