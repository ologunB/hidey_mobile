import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mms_app/core/view_models/directory_vm.dart';

import '../../../../core/models/directory_model.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/base_view.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/directory_widget.dart';
import '../../../widgets/download_status.dart';
import '../../../widgets/search_field.dart';
import '../../../widgets/text_widgets.dart';

class FlagDirectoryView extends StatefulWidget {
  const FlagDirectoryView({Key? key}) : super(key: key);

  @override
  State<FlagDirectoryView> createState() => _FlagDirectoryViewState();
}

class _FlagDirectoryViewState extends State<FlagDirectoryView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<DirectoryViewModel>(
      onModelReady: (m) {
        m.getSharedDir();
        m.getSharedFiles();
      },
      builder: (_, DirectoryViewModel model, __) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            title: RegularText(
              'Shared',
              color: AppColors.black,
              textAlign: TextAlign.center,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
            centerTitle: true,
            leading: HideyBackButton(),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [DownloadWidget()],
                ),
              )
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 100), () {});
                model.getSharedDir();
                model.getSharedFiles();
                return;
              },
              color: AppColors.red,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
                    child: SearchFormField(
                      hintMessage: 'Search',
                      typeOfInput: TextInputType.text,
                    ),
                  ),
                  model.busy
                      ? Container(
                          height: 300.h,
                          alignment: Alignment.center,
                          child: CustomLoader(),
                        )
                      : Column(
                          children: [
                            if (model.callError != null)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RegularText(
                                      model.callError!,
                                      color: AppColors.red,
                                      textAlign: TextAlign.center,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 8.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 150.h),
                                      child: GeneralButton(
                                        text: 'Retry',
                                        onPressed: () {
                                          model.getSharedDir();
                                          model.getSharedFiles();
                                        },
                                        height: 40,
                                        primColor: AppColors.white,
                                        textColor: AppColors.primaryColor,
                                        borderColor: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            _buildDirectoryList(model)
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDirectoryList(DirectoryViewModel vm) {
    List<DirectoryModel> allDirs = [];
    allDirs.addAll(vm.sharedDir?.files ?? []);
    allDirs.addAll(vm.sharedDir?.subDirectories ?? []);
    allDirs.addAll(vm.sharedFiles?.files ?? []);
    allDirs.addAll(vm.sharedFiles?.subDirectories ?? []);

    return allDirs.isEmpty
        ? Container(
            height: 300.h,
            alignment: Alignment.center,
            child: RegularText(
              'No directory/files has been added',
              color: AppColors.black,
              textAlign: TextAlign.center,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.h,
              mainAxisSpacing: 16.h,
              children: allDirs
                  .map((dir) => DirectoryWidget(addMargin: false, dir: dir))
                  .toList(),
            ),
          );
  }
}
