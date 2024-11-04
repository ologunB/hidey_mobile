import 'package:mms_app/views/user/home/profile.dart';

import '../../../core/utils/others.values.dart';
import '../../widgets/__exports.dart';
import '../../widgets/chat_row.dart';
import '../../widgets/custom_tab.dart';
import '../../widgets/search_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 0;
  bool showSearch = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            _focusNode.unfocus();
            showSearch = false;
            setState(() {});
          },
        ),
        title: RegularText(
          'Quincey_69',
          color: AppColors.darkGray,
          fontSize: 16.sp,
          height: 16.9 / 16,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: HideyImage(
              'write_chat',
              both: 40,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: ListView(
            children: [
              if (!showSearch)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchFormField(
                              hintMessage: 'Search',
                              typeOfInput: TextInputType.text,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  showSearch = true;
                                  setState(() {});
                                },
                                child: RegularText(
                                  'Filter',
                                  color: AppColors.primaryColor,
                                  fontSize: 16.sp,
                                  height: 16.9 / 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    CustomTabBar(
                      tabItems: ['Primary', 'General', 'Requests'],
                      selectedIndex: selectedIndex,
                      onTabSelected: (index) {
                        setState(() {
                          selectedIndex = index;
                          setState(() {});
                        });
                      },
                    ),
                    30.verticalSpace,
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return ChatRowWidget(
                          item: chatList[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  isPersonalProfile: false,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, _) {
                        return SizedBox(height: 28);
                      },
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchFormField(
                              hintMessage: 'Search',
                              autoFocus: true,
                              focusNode: _focusNode,
                              typeOfInput: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        return SearchChatWidget(
                          name: people[index],
                        );
                      },
                      separatorBuilder: (context, _) {
                        return SizedBox(height: 8);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
