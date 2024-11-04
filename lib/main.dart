import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/views/widgets/colors.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/navigator.dart';
import 'core/apis/encryption_tool.dart';
import 'core/storage/local_storage.dart';
import 'locator.dart';
import 'views/auth/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCache.init(); //Initialize hive
  await EncryptionTool.init(); //Initialize sodium
  await FFmpegKitConfig.init(); //Initialize ffmpeg
  await FFmpegKitConfig.enableLogs();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  setupLocator();
  await GlobalConfiguration().loadFromAsset('.config');
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    IsolateNameServer.removePortNameMapping('hidey_send_port');

    bool a = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'hidey_send_port');

    print('a: $a');
    _port.listen((dynamic data) {
      //  String id = data[0];
      int status = data[1];
      int progress = data[2];
      print('status value: $status');
      print('progress value: $progress');
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('hidey_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('hidey_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: allProviders,
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, builder) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hidey',
          theme: ThemeData(
            textTheme: GoogleFonts.heeboTextTheme(Theme.of(context).textTheme),
            primaryColor: AppColors.primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashScreen(),
          navigatorKey: AppNavigator.navKey,
          onGenerateRoute: AppRouter.generateRoutes,
        ),
      ),
    );
  }
}

// xibise@clout.wiki: QmU9VDfK2ZU3j7fM3pUbHkMygTldkvGuj1Wd2KtA51s=
// Topetope@17
