import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/blocs/directory_bloc.dart';
import 'package:mms_app/core/models/task_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../user/directory/download_status_view.dart';

class DownloadWidget extends StatefulWidget {
  const DownloadWidget({Key? key}) : super(key: key);

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, ZTask>>(
      initialData: {},
      stream: directoryBloc.outDownloadProgress,
      builder: (context, snapshot) {
        if (snapshot.data?.isEmpty ?? false) return SizedBox();
        Map<String, ZTask> all = snapshot.data!;

        ZTask task = all.values.first;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => DownloadStatusView(),
                  ),
                );
              },
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: CircularProgressIndicator(
                  /*              radius: 15.h,
                  lineWidth: 5.h,
                  percent: task.progress! / task.total!,
                  center: RegularText(
                    all.length.toString(),
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: AppColors.primaryColor,*/
                  backgroundColor: AppColors.lightGrey,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
