import '__exports.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabItems;
  final int selectedIndex;
  final Function(int) onTabSelected;

  CustomTabBar({
    required this.tabItems,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.tabItems.length, (index) {
        final isSelected = index == widget.selectedIndex;
        return GestureDetector(
          onTap: () {
            widget.onTabSelected(index);
          },
          child: Container(
            width: 110.w,
            margin: EdgeInsets.only(right: index == 2 ? 0 : 16),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColorLight
                  : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: RegularText(
              widget.tabItems[index],
              color: isSelected ? AppColors.primaryColor : AppColors.black,
              fontSize: 14.sp,
              height: 16.9 / 14,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }
}
