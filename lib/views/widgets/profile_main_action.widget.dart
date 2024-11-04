import '__exports.dart';

class ProfileMainActionWidget extends StatelessWidget {
  const ProfileMainActionWidget({
    super.key,
    required this.titleOne,
    required this.titleTwo,
    required this.isProfile,
  });
  final String titleOne;
  final String titleTwo;
  final bool isProfile;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 182.w,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          decoration: BoxDecoration(
            color: isProfile ? AppColors.lightGrey : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RegularText(
                  titleOne,
                  color: isProfile ? AppColors.darkGray : AppColors.white,
                  fontSize: 14.sp,
                  height: 16.9 / 14,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                // if (!isProfile)
                //   Row(
                //     children: [
                //       10.horizontalSpace,
                //       RotatedBox(
                //         quarterTurns: 3,
                //         child: Icon(
                //           Icons.arrow_back_ios_rounded,
                //           size: 15,
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
        ),
        10.horizontalSpace,
        Container(
          width: 182.w,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RegularText(
            titleTwo,
            color: AppColors.darkGray,
            fontSize: 14.sp,
            height: 16.9 / 14,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
