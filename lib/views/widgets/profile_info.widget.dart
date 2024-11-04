import '__exports.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HideyImage(
          'user_image',
          both: 120,
        ),
        12.horizontalSpace,
        Column(
          children: [
            RegularText(
              'Followers',
              color: AppColors.darkGray,
              fontSize: 16.sp,
              height: 16.9 / 16,
              fontWeight: FontWeight.w500,
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
              color: AppColors.darkGray,
              fontSize: 16.sp,
              height: 16.9 / 16,
              fontWeight: FontWeight.w500,
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
              color: AppColors.darkGray,
              fontSize: 16.sp,
              height: 16.9 / 16,
              fontWeight: FontWeight.w500,
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
    );
  }
}
