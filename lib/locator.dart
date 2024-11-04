import 'package:get_it/get_it.dart';
import 'package:mms_app/core/apis/directory_api.dart';
import 'package:mms_app/core/view_models/directory_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/apis/auth_api.dart';
import 'core/apis/video_api.dart';
import 'core/view_models/auth_vm.dart';
import 'core/view_models/video_vm.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthApi());
  locator.registerFactory(() => AuthViewModel());

  locator.registerLazySingleton(() => DirectoryApi());
  locator.registerFactory(() => DirectoryViewModel());

  locator.registerLazySingleton(() => VideoApi());
  locator.registerFactory(() => VideoViewModel());
}

final List<SingleChildWidget> allProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  ChangeNotifierProvider<VideoViewModel>(create: (_) => VideoViewModel()),
  ChangeNotifierProvider<DirectoryViewModel>(
      create: (_) => DirectoryViewModel()),
];
