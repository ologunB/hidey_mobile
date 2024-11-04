import 'package:flutter/material.dart';
import 'package:mms_app/core/blocs/directory_bloc.dart';
import 'package:mms_app/core/models/task_model.dart';

import '../../widgets/back_button.dart';
import '../../widgets/download_tile.dart';
import '../../widgets/text_widgets.dart';

class DownloadStatusView extends StatelessWidget {
  const DownloadStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: HideyBackButton(),
        title: RegularText(
          'Uploads',
          color: AppColors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilder<Map<String, ZTask>>(
        stream: directoryBloc.outDownloadProgress,
        initialData: {},
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? false)
            return Center(
              child: RegularText(
                'No file is uploading',
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          Map<String, ZTask> all = snapshot.data!;
          return ListView.builder(
            itemCount: all.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, i) {
              ZTask task = all.values.toList()[i];
              return DownloadTile(zTask: task);
            },
          );
        },
      ),
    );
  }
}
