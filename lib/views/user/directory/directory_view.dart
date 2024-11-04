import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mms_app/core/blocs/directory_bloc.dart';
import 'package:mms_app/core/view_models/directory_vm.dart';
import 'package:mms_app/views/widgets/filter_toggle.dart';
import 'package:provider/provider.dart';

import '../../../core/models/directory_model.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/view_models/video_vm.dart';
import '../../widgets/base_view.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/directory_grid.dart';
import '../../widgets/directory_tile.dart';
import '../../widgets/download_status.dart';
import '../../widgets/filter_switch.dart';
import '../../widgets/grid_list_switch.dart';
import '../../widgets/search_field.dart';
import '../../widgets/text_widgets.dart';

class DirectoryView extends StatefulWidget {
  const DirectoryView({Key? key}) : super(key: key);

  @override
  State<DirectoryView> createState() => _DirectoryViewState();
}

class _DirectoryViewState extends State<DirectoryView> {
  DirectoryViewModel? vm;
  StreamSubscription? _listenerClosePage;
  VideoViewModel? videoVm;

  @override
  initState() {
    vm = context.read<DirectoryViewModel>();
    videoVm = context.read<VideoViewModel>();
    videoVm?.prepareJobsDir();
    _listenerClosePage = directoryBloc.outHomeDirs.listen((dynamic onData) {
      setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    _listenerClosePage?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DirectoryViewModel>(
      onModelReady: (m) {
        return m.getDirsFiltered(
          recent: selectedType == 0,
          favorite: selectedType == 1,
          file: true,
          directory: true,
        );
      },
      builder: (_, DirectoryViewModel model, __) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 100), () {});
                return model.getDirsFiltered(
                  recent: selectedType == 0,
                  favorite: selectedType == 1,
                  file: true,
                  directory: true,
                );
              },
              color: AppColors.red,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchFormField(
                            hintMessage: 'Search',
                            typeOfInput: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [DownloadWidget()],
                          ),
                        )
                      ],
                    ),
                  ),
                  //

                  model.busy
                      ? vm?.parentDirectories == null
                          ? Container(
                              height: 300.h,
                              alignment: Alignment.center,
                              child: CustomLoader(),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 2.h,
                                  child: LinearProgressIndicator(
                                    backgroundColor: AppColors.white,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                _buildDirectoryList()
                              ],
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
                                          model.fetchRootDirs();
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
                            _buildDirectoryList()
                          ],
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDirectoryList() {
    String type = selectedType == 0 ? 'folders' : 'files';
    List<DirectoryModel> allDirs = [];
    Map<String, List<DirectoryModel>>? selectedDirectories =
        vm?.homeDirectories?[type];

    allDirs = selectedDirectories?['folders'] != null
        ? selectedDirectories!['folders'] ?? []
        : selectedDirectories?['files'] ?? [];

    // vm?.parentDirectories[directoryBloc.rootId]?.values.forEach((element) {
    //   allDirs.addAll(element);
    // });

    void sortItemsFunction(
      String sort,
    ) {
      if (sort == 'Name') {
        allDirs.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      } else if (sort == 'Last modified') {
        allDirs.sort((a, b) => DateTime.parse(b.updatedAt!)
            .compareTo(DateTime.parse(a.updatedAt!)));
      } else if (sort == 'Oldest') {
        allDirs.sort((a, b) => DateTime.parse(a.createdAt!)
            .compareTo(DateTime.parse(b.createdAt!)));
      } else if (sort == 'Storage used') {
        allDirs.sort((a, b) => b.size!.toInt().compareTo(a.size!.toInt()));
      } else {
        allDirs.sort((a, b) => DateTime.parse(a.createdAt!)
            .compareTo(DateTime.parse(b.createdAt!)));
      }
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Row(
            children: [
              FilterSwitch(
                firstTitle: 'Folders',
                secondTitle: 'Files',
                selectedType: selectedType,
                onTapFolders: () {
                  selectedType = 0;
                  vm?.getDirsFiltered(
                    recent: selectedType == 0,
                    favorite: selectedType == 1,
                    file: false,
                    directory: true,
                  );
                  setState(() {});
                },
                onTapFiles: () {
                  selectedType = 1;
                  vm?.getDirsFiltered(
                    recent: selectedType == 0,
                    favorite: selectedType == 1,
                    file: true,
                    directory: false,
                  );
                  setState(() {});
                },
              ),
              Spacer(),
              Row(
                children: [
                  FilterArrow(
                    onTapSwitch: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) {
                          return Container(
                            height: 350.h,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 20,
                                  ),
                                  child: RegularText(
                                    'Sort by',
                                    color: AppColors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                const Divider(
                                  thickness: 1,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filterOptions.length,
                                    padding: EdgeInsets.only(left: 1),
                                    clipBehavior: Clip.none,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        leading: selectedFilterIndex == i
                                            ? Icon(
                                                Icons.arrow_downward,
                                                color: AppColors.black,
                                                size: 20,
                                              )
                                            : SizedBox.shrink(),
                                        title: RegularText(
                                          filterOptions[i],
                                          color: AppColors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          selectedFilterIndex = i;
                                          setState(() {
                                            sortItemsFunction(filterOptions[
                                                selectedFilterIndex]);
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                40.verticalSpace,
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  15.horizontalSpace,
                  GridListSwitch(
                    onChanged: (a) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        allDirs.isEmpty
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
            : AppCache.getGridType()
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.h,
                      mainAxisSpacing: 16.h,
                      children:
                          allDirs.map((e) => DirectoryGrid(dir: e)).toList(),
                    ),
                  )
                : ListView.builder(
                    itemCount: allDirs.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    itemBuilder: (context, i) {
                      return DirectoryTile(dir: allDirs[i]);
                    },
                  ),
      ],
    );
  }

  int selectedType = 0;
  int selectedFilterIndex = 0;
  List<String> filterOptions = [
    'Name',
    'Last modified',
    'Oldest',
    'Storage used'
  ];
}
