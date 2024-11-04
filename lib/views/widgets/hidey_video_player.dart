import 'package:flutter/material.dart';
import 'package:mms_app/core/apis/encryption_tool.dart';
import 'package:mms_app/core/models/directory_model.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:video_viewer/video_viewer.dart';

import '../../core/storage/local_storage.dart';
import '../../core/view_models/directory_vm.dart';
import 'base_view.dart';
import 'custom_loader.dart';

class HideyVideoPlayer extends StatelessWidget {
  const HideyVideoPlayer(this.dir);

  final DirectoryModel dir;

  @override
  Widget build(BuildContext context) {
    String? secretKey = EncryptionTool.readKey();
    String? publicKey = AppCache.getUser()?.publicKey;
    return BaseView<DirectoryViewModel>(
      onModelReady: (m) => m.getOneFile(dir.id!),
      builder: (_, DirectoryViewModel model, __) => model.busy
          ? Container(
              height: 300.h,
              alignment: Alignment.center,
              child: CustomLoader(),
            )
          : model.oneFile == null
              ? RegularText(
                  'An error has occurred',
                  color: const Color(0xff000000),
                  fontSize: 20.h,
                  fontWeight: FontWeight.w500,
                )
              : Scaffold(
                  body: FutureBuilder<Map<String, VideoSource>>(
                    future: VideoSource.fromM3u8PlaylistUrl(
                      "http://api.hideyprivacy.com/v1/file/video/${dir.id}/master.m3u8",
                      formatter: (q) =>
                          q == "Auto" ? "Automatic" : "${q.split("x").last}p",
                      headers: {
                        'Authorization': 'Bearer ${AppCache.getToken()}',
                        'secretKey': secretKey!,
                        'publicKey': publicKey!,
                        'shouldDecrypt': 'true',
                        'encryptionKey':
                            model.oneFile!.privileges!.first.decryptionKey!
                      },
                    ),
                    builder: (_, data) {
                      return data.hasData
                          ? VideoViewer(
                              source: data.data!,
                              autoPlay: true,
                              onFullscreenFixLandscape: true,
                              style: VideoViewerStyle(
                                thumbnail: Container(
                                  color: AppColors.primaryColor.withOpacity(.4),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor),
                              ),
                            );
                    },
                  ),
                ),
    );
  }
}
