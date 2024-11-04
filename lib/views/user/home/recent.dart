import 'package:mms_app/core/navigation/navigator.dart';
import 'package:mms_app/views/widgets/svg_button.dart';

import '../../widgets/__exports.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key}) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        child: ListView(
          children: [
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
              padding: EdgeInsets.symmetric(horizontal: 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.h,
                mainAxisSpacing: 3.w,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    AppNavigator.navigateTo(Newpost, arguments: 'image_$index');
                  },
                  child: Hero(
                    tag: 'image_$index',
                    child: HideyImage(
                      'recent1',
                      height: 140.h,
                      width: 140.w,
                    ),
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
