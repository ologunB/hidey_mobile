import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:mms_app/core/blocs/directory_bloc.dart';
import 'package:mms_app/views/user/search/search.dart';
import 'package:mms_app/views/user/chat/chat.dart';
import 'package:mms_app/views/widgets/custom_image.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/models/directory_model.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/option_dialog.dart';
import 'directory/directory_view.dart';
import 'home/home_view.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({Key? key}) : super(key: key);

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

GlobalKey<ScaffoldState> mainLayoutScaffoldKey = GlobalKey<ScaffoldState>();

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (_selectedIndex == 0) {
      DateTime now = DateTime.now();
      int timeDiff = now.difference(currentBackPressTime).inSeconds;
      if (timeDiff > 2) {
        currentBackPressTime = now;
        return Future.value(false);
      }
      currentBackPressTime = now;
      return Future.value(true);
    } else {
      _onItemTapped(0);
      setState(() {});
      return false;
    }
  }

  DateTime currentBackPressTime = DateTime.now();

  final screens = [
    const HomeView(),
    const SearchScreen(),
    const ChatScreen(),
    const DirectoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
          key: mainLayoutScaffoldKey,
          floatingActionButton: (_selectedIndex == 2 || _selectedIndex == 1)
              ? null
              : StreamBuilder<String>(
                  stream: directoryBloc.outRootId,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return SizedBox();
                    return Padding(
                      padding: EdgeInsets.only(bottom: 25.h, right: 15.w),
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return OptionDialog(
                                dir: DirectoryModel(id: snapshot.data),
                              );
                            },
                          );
                        },
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.add_rounded,
                          size: 28.h,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
          backgroundColor: Colors.transparent,
          drawer: HideyDrawer(),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.gray,
            iconSize: 20.h,
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: HideyImage(
                  'home',
                  both: 25.h,
                  color: AppColors.gray,
                ),
                activeIcon: HideyImage(
                  'home',
                  both: 25.h,
                  color: AppColors.primaryColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: HideyImage(
                  'search',
                  both: 25.h,
                  color: AppColors.gray,
                ),
                activeIcon: HideyImage(
                  'search',
                  both: 25.h,
                  color: AppColors.primaryColor,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: HideyImage(
                  'chat_nav',
                  both: 25.h,
                  color: AppColors.gray,
                ),
                activeIcon: HideyImage(
                  'chat_nav',
                  both: 25.h,
                  color: AppColors.primaryColor,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: HideyImage(
                  'directory_nav',
                  both: 25.h,
                  color: AppColors.gray,
                ),
                activeIcon: HideyImage(
                  'directory_nav',
                  both: 25.h,
                  color: AppColors.primaryColor,
                ),
                label: 'Drive',
              ),
            ],
          ),
          body: screens[_selectedIndex]),
    );
  }
}
