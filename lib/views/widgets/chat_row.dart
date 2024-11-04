import '../../core/models/user_story.model.dart';
import '__exports.dart';

class ChatRowWidget extends StatelessWidget {
  const ChatRowWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final StoryModel item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                item.name ?? "",
                color: AppColors.black,
                fontSize: 16.sp,
                height: 18.9 / 16,
                fontWeight: FontWeight.w500,
              ),
              6.verticalSpace,
              RobotoText(
                item.text ?? '',
                color: AppColors.black,
                fontSize: 14.sp,
                height: 14.9 / 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          Spacer(),
          RobotoText(
            '3:30 am',
            color: AppColors.darkGray,
            fontSize: 14.sp,
            height: 14.9 / 14,
            fontWeight: FontWeight.w400,
          ),
          10.horizontalSpace,
        ],
      ),
    );
  }
}
