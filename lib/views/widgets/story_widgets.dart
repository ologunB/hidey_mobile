import 'package:flutter/material.dart';
import 'package:mms_app/views/widgets/custom_image.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/models/user_story.model.dart';

class AddStoryWidget extends StatelessWidget {
  const AddStoryWidget({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGrey,
              ),
              child: HideyImage(
                'add_story',
                both: 18,
              ),
            ),
            8.verticalSpace,
            RobotoText(
              'Your story',
              color: AppColors.gray,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class UserStoryWidget extends StatelessWidget {
  const UserStoryWidget({
    super.key,
    required this.user,
  });

  final StoryModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            child: HideyImage(
              user.imagePath ?? 'profile',
              both: 64,
            ),
          ),
          8.verticalSpace,
          RobotoText(
            user.name ?? '',
            color: AppColors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
