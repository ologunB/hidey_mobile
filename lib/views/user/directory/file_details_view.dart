import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/directory_model.dart';
import '../../../core/view_models/directory_vm.dart';
import '../../widgets/back_button.dart';
import '../../widgets/base_view.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/file_more_options.dart';
import '../../widgets/hidey_video_player.dart';
import '../../widgets/text_widgets.dart';

class FileDetailsScreen extends StatefulWidget {
  const FileDetailsScreen({Key? key, required this.dir}) : super(key: key);
  final DirectoryModel dir;
  @override
  State<FileDetailsScreen> createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  static const platform = const MethodChannel('hidey.privacy.com');

  @override
  void initState() {
    openCapturing();
    super.initState();
  }

  @override
  void dispose() {
    closeCapturing();
    super.dispose();
  }

  openCapturing() async {
    final String version = await platform.invokeMethod('start_video');
    print('Platform version is $version');
  }

  closeCapturing() async {
    final String version = await platform.invokeMethod('stop_video');
    print('Platform version is $version');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: HideyBackButton(),
        title: RegularText(
          widget.dir.name!,
          color: const Color(0xff000000),
          fontSize: 20.h,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FileMoreOptions(dir: widget.dir),
                //  DownloadWidget()
              ],
            ),
          )
        ],
      ),
      body: ['MP4', 'MOV'].contains(widget.dir.mimeType?.toUpperCase())
          ? HideyVideoPlayer(widget.dir)
          : BaseView<DirectoryViewModel>(
              onModelReady: (m) => m.getFile(widget.dir.id!),
              builder: (_, DirectoryViewModel model, __) => model.busy
                  ? Container(
                      height: 300.h,
                      alignment: Alignment.center,
                      child: CustomLoader(),
                    )
                  : model.presentFile == null
                      ? RegularText(
                          'An error has occurred',
                          color: const Color(0xff000000),
                          fontSize: 20.h,
                          fontWeight: FontWeight.w500,
                        )
                      : widget.dir.mimeType?.toUpperCase() == 'TXT' // open text
                          ? Text(String.fromCharCodes(model.presentFile!))
                          : [
                              'PNG',
                              'JPG',
                              'JPEG',
                              'IMAGE/JPEG',
                              'GIF',
                              'IMAGE/WEBP',
                              'IMAGE/PNG'
                            ].contains(widget.dir.mimeType?.toUpperCase())
                              ? Image.memory(
                                  model.presentFile!,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : RegularText(
                                  'The type:${widget.dir.mimeType} cannot be opened',
                                  color: const Color(0xff000000),
                                  fontSize: 20.h,
                                  fontWeight: FontWeight.w500,
                                ),
            ),
    );
  }
}
