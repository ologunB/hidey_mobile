import 'package:flutter/material.dart';

import '../../core/storage/local_storage.dart';
import 'text_widgets.dart';

class GridListSwitch extends StatefulWidget {
  const GridListSwitch({Key? key, required this.onChanged}) : super(key: key);

  final Function(bool) onChanged;
  @override
  State<GridListSwitch> createState() => _GridListSwitchState();
}

class _GridListSwitchState extends State<GridListSwitch> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppCache.setGridType(!AppCache.getGridType());
        widget.onChanged(AppCache.getGridType());
        setState(() {});
      },
      borderRadius: BorderRadius.circular(30.h),
      child: Container(
        padding: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(
          AppCache.getGridType()
              ? Icons.menu_rounded
              : Icons.dashboard_outlined,
          color: AppColors.black,
          size: 28.h,
        ),
      ),
    );
  }
}
