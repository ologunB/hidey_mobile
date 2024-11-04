import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'custom_image.dart';

class SearchChatWidget extends StatelessWidget {
  const SearchChatWidget({
    super.key,
    required this.name,
    this.onTapChat,
    this.onTapProfile,
  });
  final String name;
  final void Function()? onTapChat;
  final void Function()? onTapProfile;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTapProfile,
          child: Row(
            children: [
              HideyImage(
                'user_image',
                both: 48,
              ),
              8.horizontalSpace,
              RobotoText(
                name,
                color: AppColors.black,
                fontSize: 16.sp,
                height: 18.9 / 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onTapChat,
          child: RobotoText(
            'Chat',
            color: AppColors.primaryColor,
            fontSize: 16.sp,
            height: 18.9 / 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        18.horizontalSpace,
      ],
    );
  }
}
