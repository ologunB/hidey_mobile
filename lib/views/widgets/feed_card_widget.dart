import 'package:mms_app/core/navigation/navigator.dart';

import '__exports.dart';
import 'grid_image_widget.dart';

class FeedCardWidget extends StatelessWidget {
  const FeedCardWidget({
    super.key,
    required this.isLocked,
    required this.name,
    required this.profileUrl,
    required this.imageUrl,
    required this.titleText,
    this.onTap,
    this.onTapAction,
  });
  final String name;
  final String profileUrl;
  final String imageUrl;
  final String titleText;
  final bool isLocked;
  final void Function()? onTap;
  final void Function()? onTapAction;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                HideyImage(
                  profileUrl,
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
            Spacer(),
            HideyImage(
              onTap: onTapAction,
              'three_dots',
              height: 24.h,
              width: 24.w,
            ),
          ],
        ),
        12.verticalSpace,
        RegularText(
          titleText,
          color: AppColors.darkGray.withOpacity(0.6),
          fontSize: 14.sp,
          height: 16.9 / 14,
          fontWeight: FontWeight.w400,
        ),
        if (isLocked)
          Column(
            children: [
              16.verticalSpace,
              FourImageGrid(),
              GestureDetector(
                onTap: () => AppNavigator.navigateTo(Addcardscreen),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: RegularText(
                    'Unlock with \$5',
                    color: AppColors.white,
                    fontSize: 14.sp,
                    height: 16.9 / 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              16.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Center(
                  child: Image.asset(
                    imageUrl,
                    height: 408.h,
                    width: 380.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        16.verticalSpace,
        Row(
          children: [
            HideyImage(
              'heart',
              height: 20.h,
              width: 20.w,
            ),
            HideyImage(
              'profile',
              height: 16.h,
              width: 40.w,
            ),
            RegularText(
              'Liked by ',
              color: AppColors.gray,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
            RegularText(
              'Jenny_will and 2,359 ',
              color: AppColors.black,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
            RegularText(
              'others',
              color: AppColors.gray,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        4.verticalSpace,
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              HideyImage(
                'comment',
                height: 20.h,
                width: 20.w,
              ),
              8.horizontalSpace,
              RegularText(
                'View all 100 comments',
                color: AppColors.gray,
                fontSize: 14.sp,
                height: 16.9 / 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        8.verticalSpace,
        Row(
          children: [
            RegularText(
              'Jenny_will ',
              color: AppColors.black,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
            RegularText(
              'Go girl 💕 ',
              color: AppColors.gray,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        4.verticalSpace,
        RegularText(
          '20 minutes',
          color: AppColors.gray,
          fontSize: 8.sp,
          height: 9 / 8,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
