import 'package:mms_app/core/navigation/navigator.dart';

import '__exports.dart';

class ReqNotificationWidget extends StatelessWidget {
  const ReqNotificationWidget({
    super.key,
    required this.showAccept,
    required this.showDecline,
  });
  final bool showDecline;
  final bool showAccept;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => AppNavigator.navigateTo(Viewrequestscreen),
          child: Row(
            children: [
              HideyImage(
                'user_image',
                both: 48,
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RobotoText(
                    'Cameron Williamson',
                    color: AppColors.black,
                    fontSize: 16.sp,
                    height: 18.9 / 16,
                    fontWeight: FontWeight.w500,
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      RobotoText(
                        'Sent you a friend request.',
                        color: AppColors.darkGray.withOpacity(.6),
                        fontSize: 14.sp,
                        height: 15.9 / 14,
                        fontWeight: FontWeight.w400,
                      ),
                      5.horizontalSpace,
                      RobotoText(
                        '9h',
                        color: AppColors.darkGray.withOpacity(.6),
                        fontSize: 14.sp,
                        height: 15.9 / 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        Row(
          children: [
            if (!showDecline && !showAccept)
              Row(
                children: [
                  RobotoText(
                    'Decline',
                    color: Color(0xffFB2C2C),
                    fontSize: 14.sp,
                    height: 15.9 / 14,
                    fontWeight: FontWeight.w400,
                  ),
                  8.horizontalSpace,
                  RobotoText(
                    'Accept',
                    color: Color(0xff0066F5),
                    fontSize: 14.sp,
                    height: 15.9 / 14,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            if (showAccept)
              RobotoText(
                'Accepted',
                color: Color(0xffFB2C2C),
                fontSize: 14.sp,
                height: 15.9 / 14,
                fontWeight: FontWeight.w400,
              ),
            if (showDecline)
              RobotoText(
                'Declined',
                color: Color(0xffFB2C2C),
                fontSize: 14.sp,
                height: 15.9 / 14,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),
      ],
    );
  }
}
