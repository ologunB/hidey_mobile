import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/views/auth/view_private_key.dart';

import '../../widgets/back_button.dart';
import '../../widgets/text_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF5F5F5),
        leading: HideyBackButton(),
        centerTitle: true,
        title: RegularText(
          'Settings',
          color: const Color(0xff1A1A1A),
          fontSize: 24.sp,
          height: 29 / 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: ListView.builder(
          itemCount: a.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (c, i) {
            return InkWell(
              onTap: () {
                if (i == 3) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ViewPrivateKeyScreen(),
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/s$i.png',
                      height: 24.h,
                    ),
                    SizedBox(width: 20.h),
                    RegularText(
                      a[i],
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<String> get a => ['Security', 'Profile', 'Theme', 'Private Key'];
}
