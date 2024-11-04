import 'package:flutter/material.dart';
import 'package:mms_app/core/navigation/navigator.dart';

import '../../widgets/custom_image.dart';
import '../../widgets/profile_info.widget.dart';
import '../../widgets/profile_main_action.widget.dart';
import '../../widgets/text_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isPersonalProfile,
  });
  final bool isPersonalProfile;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            AppNavigator.doPop();
          },
        ),
        title: RegularText(
          'Quincey Roland',
          color: AppColors.darkGray,
          fontSize: 16.sp,
          height: 16.9 / 16,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: HideyImage(
              'three_dots',
              height: 24.h,
              width: 24.w,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileInfoWidget(),
                16.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      'Quincey Roland',
                      color: AppColors.darkGray,
                      fontSize: 14.sp,
                      height: 14.9 / 14,
                      fontWeight: FontWeight.w500,
                    ),
                    4.verticalSpace,
                    RegularText(
                      "Chasing my dreams and living my best life! 🌟\n#blessed #grateful #nevergiveup",
                      color: AppColors.darkGray,
                      fontSize: 14.sp,
                      height: 14.9 / 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                24.verticalSpace,
                ProfileMainActionWidget(
                  titleOne:
                      widget.isPersonalProfile ? 'Edit profile' : 'Follow',
                  titleTwo: widget.isPersonalProfile ? 'Requests' : 'Message',
                  isProfile: widget.isPersonalProfile,
                ),
                24.verticalSpace,
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.h,
              mainAxisSpacing: 3.w,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Hero(
                  tag: 'image_$index',
                  child: HideyImage(
                    'recent1',
                    height: 140.h,
                    width: 140.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
