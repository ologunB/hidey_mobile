import 'package:mms_app/core/navigation/navigator.dart';

import '../../widgets/__exports.dart';
import '../../widgets/svg_button.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({
    Key? key,
    this.tag,
  }) : super(key: key);
  final String? tag;
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => AppNavigator.doPop(),
                    child: HideyImage(
                      'arrow_back',
                      both: 24,
                    ),
                  ),
                  110.horizontalSpace,
                  RegularText(
                    'New Post',
                    color: AppColors.darkGray,
                    fontSize: 24.sp,
                    height: 16.9 / 14,
                    fontWeight: FontWeight.w500,
                  ),
                  Spacer(),
                  RegularText(
                    'Next',
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    height: 16.9 / 16,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Center(
                child: Hero(
                  tag: widget.tag ?? '',
                  child: Image.asset(
                    'assets/images/feed_image.png',
                    height: 408.h,
                    width: 380.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            49.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Row(
                    children: [
                      RegularText(
                        'Recent',
                        color: AppColors.darkGray,
                        fontSize: 24.sp,
                        height: 25.9 / 24,
                        fontWeight: FontWeight.w500,
                      ),
                      4.horizontalSpace,
                      SVGButton(
                        path: 'assets/icons/arrow_down.svg',
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.lightGrey),
                    child: SVGButton(
                      path: 'assets/icons/camera.svg',
                    ),
                  ),
                ],
              ),
            ),
            33.verticalSpace,
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0.h,
                mainAxisSpacing: 0.w,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      HideyImage(
                        'recent1',
                        height: 140.h,
                        width: 140.w,
                      ),
                      Positioned(
                        right: 2,
                        bottom: 110.h,
                        child: HideyImage(
                          'checkSquare',
                          both: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
