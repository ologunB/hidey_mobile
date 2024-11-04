import 'dart:async';

import 'package:mms_app/core/navigation/navigator.dart';
import 'package:mms_app/views/widgets/svg_button.dart';

import '../../../core/utils/others.values.dart';
import '../../widgets/__exports.dart';
import '../../widgets/feed_card_widget.dart';
import '../../widgets/story_widgets.dart';
import '../main_layout.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FocusNode _commentFocusNode = FocusNode();
  bool _isCommentVisible = false;
  // DirectoryViewModel? vm;
  // VideoViewModel? videoVm;
  // StreamSubscription? _listenerClosePage;

  // @override
  // initState() {
  //   vm = context.read<DirectoryViewModel>();
  //   videoVm = context.read<VideoViewModel>();
  //   videoVm?.prepareJobsDir();
  //   _listenerClosePage = directoryBloc.outHomeDirs.listen((dynamic onData) {
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  // @override
  // dispose() {
  //   _listenerClosePage?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 100), () {});
      },
      color: AppColors.primaryColor,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _isCommentVisible = false;
              });
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          mainLayoutScaffoldKey.currentState!.openDrawer();
                        },
                        child: HideyImage(
                          'drawer_icon',
                          both: 45,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          HideyImage(
                            onTap: () {
                              AppNavigator.navigateTo(RequestScreen);
                            },
                            'bellIcon',
                          ),
                          16.horizontalSpace,
                          HideyImage(
                            onTap: () {
                              AppNavigator.navigateTo(Newpost);
                            },
                            'add_icon',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                16.verticalSpace,
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24),
                    itemCount: usersStory.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return AddStoryWidget(
                          onTap: () {
                            AppNavigator.navigateTo(Recent);
                          },
                        );
                      } else {
                        final user = usersStory[index - 1];
                        return UserStoryWidget(user: user);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    itemCount: feedList.length,
                    itemBuilder: (context, index) {
                      final feedItem = feedList[index];
                      return FeedCardWidget(
                        isLocked: feedItem.isLocked ?? false,
                        name: feedItem.userName ?? '',
                        profileUrl: feedItem.profileUrl ?? '',
                        titleText: feedItem.userBio ?? '',
                        imageUrl: feedItem.imageUrl ?? '',
                        onTap: () {
                          setState(() {
                            _isCommentVisible = true;
                          });
                        },
                        onTapAction: () {
                          showBottomSheetDialog(context);
                        },
                      );
                    },
                    separatorBuilder: (context, _) {
                      return SizedBox(height: 20);
                    },
                  ),
                ),
                Visibility(
                  visible: _isCommentVisible,
                  child: CommentFormField(
                    hintMessage: '',
                    typeOfInput: TextInputType.text,
                    focusNode: _commentFocusNode,
                    onTapSuffix: () {
                      setState(() {
                        _isCommentVisible = false;
                        _commentFocusNode.unfocus();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 42.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      SVGWidget('bookMark'),
                      8.horizontalSpace,
                      RegularText(
                        'Save',
                        color: AppColors.darkGray,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SVGWidget('copy'),
                      8.horizontalSpace,
                      RegularText(
                        'Copy',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SVGWidget('share_modal'),
                      8.horizontalSpace,
                      RegularText(
                        'Share',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 0.5,
              color: AppColors.darkGray.withOpacity(0.2),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      SVGWidget('contact'),
                      8.horizontalSpace,
                      RegularText(
                        'Unfollow',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SVGWidget('mute'),
                      8.horizontalSpace,
                      RegularText(
                        'Mute account',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SVGWidget('not_interested'),
                      8.horizontalSpace,
                      RegularText(
                        'Not interested in this post',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 0.5,
              color: AppColors.darkGray.withOpacity(0.2),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      SVGWidget('about'),
                      8.horizontalSpace,
                      RegularText(
                        'About account',
                        color: AppColors.black,
                        fontSize: 16.sp,
                        height: 18.9 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
