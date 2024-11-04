import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mms_app/views/widgets/custom_image.dart';
import 'package:mms_app/views/widgets/new_dir_dialog.dart';
import 'package:mms_app/views/widgets/snackbar.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../core/models/directory_model.dart';
import '../../core/view_models/directory_vm.dart';
import '../user/directory/share/share_file_view.dart';
import 'delete_dir_dialog.dart';

class DirMoreOptions extends StatefulWidget {
  const DirMoreOptions(
      {Key? key,
      this.child,
      this.dir,
      this.addNew = false,
      this.allowTap = true})
      : super(key: key);

  final Widget? child;
  final DirectoryModel? dir;
  final bool addNew;
  final bool allowTap;

  @override
  State<DirMoreOptions> createState() => _DirMoreOptionsState();
}

class _DirMoreOptionsState extends State<DirMoreOptions> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      child: widget.child ??
          Container(
            padding: EdgeInsets.all(6.h),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(
              Icons.more_horiz,
              size: 24.h,
              color: AppColors.primaryColor,
            ),
          ),
      onTap: widget.allowTap ? () => _showMenu(context) : null,
      onLongPress: () => _showMenu(context),
    );
  }

  final GlobalKey _globalKey = GlobalKey();

  void _showMenu(BuildContext context) {
    final RenderBox button =
        _globalKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: _buildMenuItem(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItem(BuildContext context) {
    return all.map((String e) {
      int i = all.indexOf(e);
      return PopupMenuItem<String>(
        value: e,
        key: Key('filter-item-$i'),
        onTap: () => onTap(i, context),
        height: 56.h,
        child: Row(
          children: [
            HideyImage(
              'a$i',
              both: 24.h,
              color: i == 7 ? AppColors.red : null,
            ),
            SizedBox(width: 16.h),
            RegularText(
              e,
              color: i == 7 ? AppColors.red : AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      );
    }).toList();
  }

  void onTap(int a, BuildContext context) async {
    await Future.delayed(Duration.zero);
    String link = 'http://hideyprivacy.com';
    if (a == 0) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NewDirDialog(
            parentDir: widget.dir,
            openNew: widget.child == null,
          );
        },
      );
    }
    if (a == 2) {
      Clipboard.setData(ClipboardData(text: link));
      showSnackBar(context, null, 'Link Copied');
    }
    if (a == 3) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NewDirDialog(renameDir: widget.dir);
        },
      );
    }

    if (a == 6) {
      print(a);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => ShareFileScreen(dirs: [widget.dir!]),
        ),
      );
    }
    if (a == 7) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DeleteDirDialog(dir: widget.dir!, addNew: widget.addNew);
        },
      );
    }
    if (a == 8) {
      DirectoryViewModel().favorite(widget.dir!, true);
    }
  }

  List<String> get all => [
        'Create new directory',
        'Manage access',
        'Copy link',
        'Rename directory',
        'Move',
        'Details & activity',
        'Share',
        'Delete directory',
        'Favorite',
      ];
}
