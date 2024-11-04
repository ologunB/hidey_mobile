import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/navigation/navigator.dart';

import '../../widgets/custom_image.dart';
import '../../widgets/text_widgets.dart';

class PreChatScreen extends StatefulWidget {
  const PreChatScreen({
    super.key,
  });

  @override
  State<PreChatScreen> createState() => _PreChatScreenState();
}

class _PreChatScreenState extends State<PreChatScreen> {
  int selectedIndex = 0;
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.black,
                    size: 20,
                  ),
                  onPressed: () => AppNavigator.doPop(),
                ),
                HideyImage(
                  'user_image',
                  both: 48,
                ),
                8.horizontalSpace,
                RegularText(
                  'Casey_jones',
                  color: AppColors.darkGray,
                  fontSize: 16.sp,
                  height: 16.9 / 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  20.verticalSpace,
                  HideyImage(
                    'user_image',
                    both: 120,
                  ),
                  15.verticalSpace,
                  RegularText(
                    'Casey_jones',
                    color: AppColors.darkGray,
                    fontSize: 16.sp,
                    height: 16.9 / 16,
                    fontWeight: FontWeight.w400,
                  ),
                  24.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          RegularText(
                            'Followers',
                            color: AppColors.darkGray.withOpacity(0.6),
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                          4.verticalSpace,
                          RegularText(
                            '14k',
                            color: AppColors.darkGray,
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      21.horizontalSpace,
                      Column(
                        children: [
                          RegularText(
                            'Following',
                            color: AppColors.darkGray.withOpacity(0.6),
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                          4.verticalSpace,
                          RegularText(
                            '1600',
                            color: AppColors.darkGray,
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      21.horizontalSpace,
                      Column(
                        children: [
                          RegularText(
                            'Posts',
                            color: AppColors.darkGray.withOpacity(0.6),
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                          4.verticalSpace,
                          RegularText(
                            '190',
                            color: AppColors.darkGray,
                            fontSize: 16.sp,
                            height: 16.9 / 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  RegularText(
                    'You are not following this user, click the button to view their profile',
                    color: AppColors.darkGray.withOpacity(0.6),
                    fontSize: 14.sp,
                    height: 14.9 / 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      AppNavigator.navigateTo(Profile, arguments: false);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.darkGray.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RegularText(
                        'View Profile',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 16.9 / 14,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  48.verticalSpace,
                  RegularText(
                    'May 19,2023',
                    color: AppColors.darkGray.withOpacity(0.6),
                    fontSize: 14.sp,
                    height: 14.9 / 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
            Column(
              children: [
                BubbleNormal(
                  text: 'Hi babe 💓',
                  color: AppColors.lightGrey,
                  tail: true,
                  delivered: false,
                  isSender: false,
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 116.w,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RegularText(
                      'Decline',
                      color: Color(0xffFB2C2C),
                      fontSize: 14.sp,
                      height: 16.9 / 14,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 116.w,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RegularText(
                      'Delete',
                      color: Color(0xffFB2C2C),
                      fontSize: 14.sp,
                      height: 16.9 / 14,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 116.w,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RegularText(
                      'Accept',
                      color: AppColors.darkGray,
                      fontSize: 14.sp,
                      height: 16.9 / 14,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 24),
            //     child: ChatField(
            //       hintMessage: 'Message',
            //       typeOfInput: TextInputType.text,
            //       onTapSuffix: () {},
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
