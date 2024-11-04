import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mms_app/views/widgets/back_button.dart';
import 'package:mms_app/views/widgets/custom_image.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../../core/blocs/directory_bloc.dart';
import '../../../core/models/directory_model.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/view_models/directory_vm.dart';
import '../../widgets/base_view.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/delete_many_dir_dialog.dart';
import '../../widgets/dir_more_options.dart';
import '../../widgets/directory_grid.dart';
import '../../widgets/directory_tile.dart';
import '../../widgets/download_status.dart';
import '../../widgets/filter_switch.dart';
import '../../widgets/filter_toggle.dart';
import '../../widgets/grid_list_switch.dart';
import '../../widgets/option_dialog.dart';
import '../../widgets/search_field.dart';
import '../../widgets/text_widgets.dart';

class DirectoryDetailsView extends StatefulWidget {
  const DirectoryDetailsView({Key? key, required this.dir}) : super(key: key);
  final DirectoryModel dir;
  @override
  State<DirectoryDetailsView> createState() => _DirectoryDetailsViewState();
}

class _DirectoryDetailsViewState extends State<DirectoryDetailsView> {
  DirectoryViewModel? vm;
  late String id;
  StreamSubscription? _listenerClosePage;
  DirectoryModel? directoryModel;

  List<String> dirIds = [];
  List<String> fileIds = [];
  bool isSelecting = false;

  @override
  initState() {
    id = widget.dir.id!;
    vm = context.read<DirectoryViewModel>();
    _listenerClosePage = directoryBloc.outParentDirs
        .listen((Map<String, Map<String, List<DirectoryModel>>> onData) {
      directoryModel = onData[widget.dir.parentID]?[id]?.first;
      setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    _listenerClosePage?.cancel();
    super.dispose();
  }

  //
  int selectedType = 0;
  int selectedFilterIndex = 0;
  List<String> filterOptions = [
    'Name',
    'Last modified',
    'Oldest',
    'Storage used'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView<DirectoryViewModel>(
      onModelReady: (m) => m.getOneDir(widget.dir.id!),
      builder: (_, DirectoryViewModel model, __) => RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 100), () {});
          return model.getOneDir(widget.dir.id!);
        },
        color: AppColors.primaryColor,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: HideyBackButton(
              onPressed: isSelecting
                  ? () {
                      isSelecting = false;
                      dirIds = [];
                      fileIds = [];
                      setState(() {});
                    }
                  : null,
            ),
            actions: [
              if (isSelecting)
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'a2'.toImage(),
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              if (isSelecting)
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return DeleteManyDirDialog(
                              dirIds: dirIds,
                              fileIds: fileIds,
                              addNew: false,
                              parentId: widget.dir.id!,
                              onSuccess: () {
                                isSelecting = false;
                                dirIds = [];
                                fileIds = [];
                                setState(() {});
                              },
                            );
                          },
                        );
                      },
                      icon: Image.asset(
                        'a7'.toImage(),
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              if (isSelecting)
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        isSelecting = false;
                        dirIds = [];
                        fileIds = [];
                        setState(() {});
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.only(right: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [DownloadWidget()],
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 25.h, right: 15.w),
            child: FloatingActionButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return OptionDialog(dir: widget.dir);
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
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(16.h),
                  margin:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: HideyImage('type-folder', both: 24.h),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RegularText(
                                directoryModel?.name ??
                                    widget.dir.name ??
                                    'no-name',
                                color: AppColors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  RegularText(
                                    '25GB',
                                    color: AppColors.gray,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Spacer(),
                                  RegularText(
                                    '50GB',
                                    color: AppColors.gray,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: LinearProgressIndicator(
                                  value: .7,
                                  backgroundColor:
                                      AppColors.white.withOpacity(.2),
                                  valueColor:
                                      AlwaysStoppedAnimation(AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      if (!model.busy && model.oneDirectory != null)
                        DirMoreOptions(
                          dir: model.oneDirectory,
                          addNew: true,
                          child: Container(
                            padding: EdgeInsets.all(4.h),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: HideyImage('settings', both: 24.h),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.h),
                  child: SearchFormField(
                    hintMessage: 'Search',
                    typeOfInput: TextInputType.text,
                  ),
                ),
                model.busy
                    ? vm?.parentDirectories[id] == null
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 150.h),
                                    child: GeneralButton(
                                      text: 'Retry',
                                      onPressed: () {
                                        model.getOneDir(widget.dir.id!);
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
      ),
    );
  }

  Widget _buildDirectoryList() {
    List<DirectoryModel> allDirs = [];
    // String type = selectedType == 0 ? 'folders' : 'files';

    vm?.parentDirectories[id]?.values.forEach((element) {
      allDirs.addAll(element);
    });
    allDirs = allDirs.reversed.toList();

    // Map<String, List<DirectoryModel>>? selectedDirectories =
    //     vm?.homeDirectories?[type];
    // allDirs = selectedDirectories?['folders'] != null
    //     ? selectedDirectories!['folders'] ?? []
    //     : selectedDirectories?['files'] ?? [];

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

    return Column(children: [
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
            // FilterSwitch(
            //   firstTitle: 'Folders',
            //   secondTitle: 'Files',
            //   selectedType: selectedType,
            //   onTapFolders: () {
            //     selectedType = 0;
            //     setState(() {});

            //     vm?.getDirsBasedOnFlag(
            //       recent: true,
            //       file: false,
            //       directory: true,
            //     );
            //   },
            //   onTapFiles: () {
            //     selectedType = 1;
            //     setState(() {});
            //     vm?.getDirsBasedOnFlag(
            //       recent: true,
            //       file: true,
            //       directory: false,
            //     );
            //   },
            // ),
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
                'No directory/file has been added',
                color: AppColors.black,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 100), () {});
                return vm!.getOneDir(id);
              },
              color: AppColors.red,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: AppCache.getGridType()
                    ? StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.h,
                        mainAxisSpacing: 16.h,
                        children: allDirs.map((e) {
                          bool isFile = e.parentID == null;
                          bool isPresent = isFile
                              ? fileIds.contains(e.id!)
                              : dirIds.contains(e.id!);
                          return DirectoryGrid(
                            dir: e,
                            isSelected: !isSelecting ? null : isPresent,
                            onLongPress: () {
                              isSelecting = true;
                              if (isFile) {
                                if (isPresent) {
                                  fileIds.remove(e.id!);
                                } else {
                                  fileIds.add(e.id!);
                                }
                              } else {
                                if (isPresent) {
                                  dirIds.remove(e.id!);
                                } else {
                                  dirIds.add(e.id!);
                                }
                              }

                              setState(() {});
                            },
                          );
                        }).toList(),
                      )
                    : ListView.builder(
                        itemCount: allDirs.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, i) {
                          DirectoryModel e = allDirs[i];
                          bool isFile = e.parentID == null;
                          bool isPresent = isFile
                              ? fileIds.contains(e.id!)
                              : dirIds.contains(e.id!);

                          return DirectoryTile(
                            dir: e,
                            isSelected: !isSelecting ? null : isPresent,
                            onLongPress: () {
                              isSelecting = true;
                              if (isFile) {
                                if (isPresent) {
                                  fileIds.remove(e.id!);
                                } else {
                                  fileIds.add(e.id!);
                                }
                              } else {
                                if (isPresent) {
                                  dirIds.remove(e.id!);
                                } else {
                                  dirIds.add(e.id!);
                                }
                              }

                              setState(() {});
                            },
                          );
                        },
                      ),
              ),
            ),
    ]);
  }
}
