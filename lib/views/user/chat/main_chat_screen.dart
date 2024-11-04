import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/navigation/navigator.dart';
import 'package:mms_app/views/widgets/svg_button.dart';

import '../../widgets/chat_field.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/text_widgets.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({
    super.key,
  });

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  int selectedIndex = 0;
  bool showSearch = false;
  final FocusNode _chatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
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
                      'Cameron Williamson',
                      color: AppColors.darkGray,
                      fontSize: 16.sp,
                      height: 16.9 / 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    SVGWidget('videoCamera'),
                    16.horizontalSpace,
                    SVGWidget('chat_phone'),
                    16.horizontalSpace,
                    SVGWidget('verticalDots'),
                    24.horizontalSpace,
                  ],
                ),
              ],
            ),
            20.verticalSpace,
            RegularText(
              'May 19,2023',
              color: AppColors.darkGray.withOpacity(0.6),
              fontSize: 14.sp,
              height: 14.9 / 14,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Expanded(
              child: Column(
                children: [
                  BubbleNormal(
                    text: 'Hi babe 💓',
                    color: AppColors.lightGrey,
                    tail: true,
                    delivered: false,
                    isSender: false,
                    textStyle: GoogleFonts.roboto(
                      color: AppColors.black.withOpacity(.8),
                      letterSpacing: -0.21,
                      fontSize: 14,
                      height: 20.1 / 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  8.verticalSpace,
                  BubbleNormal(
                    text: 'what’s up dear 💓',
                    color: AppColors.lightGrey,
                    tail: true,
                    delivered: false,
                    isSender: true,
                    textStyle: GoogleFonts.roboto(
                      color: AppColors.black.withOpacity(.8),
                      letterSpacing: -0.21,
                      fontSize: 14,
                      height: 20.1 / 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  8.verticalSpace,
                  BubbleNormal(
                    text:
                        '''Hey, I'm thinking of starting a new workout routine. Do you have any  for fitness influencers to follow, like any recommendations?''',
                    color: AppColors.lightGrey,
                    tail: true,
                    delivered: false,
                    isSender: false,
                    textStyle: GoogleFonts.roboto(
                      color: AppColors.black.withOpacity(.8),
                      letterSpacing: -0.21,
                      fontSize: 14,
                      height: 20.1 / 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ChatField(
                hintMessage: 'Message',
                focusNode: _chatFocusNode,
                typeOfInput: TextInputType.text,
                onTapSuffix: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
