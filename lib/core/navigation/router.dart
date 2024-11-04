import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/core/models/user_model.dart';
import 'package:mms_app/views/auth/create_password.dart';
import 'package:mms_app/views/auth/signup.dart';
import 'package:mms_app/views/auth/splash_view.dart';
import 'package:mms_app/views/auth/verify_account.dart';
import 'package:mms_app/views/user/chat/main_chat_screen.dart';
import 'package:mms_app/views/user/home/add_card.dart';
import 'package:mms_app/views/user/home/new_post.dart';
import 'package:mms_app/views/user/home/profile.dart';
import 'package:mms_app/views/user/home/recent.dart';
import 'package:mms_app/views/user/home/requests.dart';
import 'package:mms_app/views/user/home/view_request_screen.dart';
import 'package:mms_app/views/user/main_layout.dart';

import '../../views/auth/forgot_password.dart';
import '../../views/auth/login.dart';
import '../../views/auth/reset_password.dart';
import '../../views/auth/verify_private_key.dart';
import '../../views/auth/view_private_key.dart';
import '../../views/user/chat/pre_chat_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case SignUpRoute:
        return getPageRoute(
          settings: settings,
          view: const Signup(),
        );
      case password:
        String firstName = settings.arguments as String;
        String lastName = settings.arguments as String;
        String email = settings.arguments as String;
        String userName = settings.arguments as String;

        return getPageRoute(
          settings: settings,
          view: CreatePassword(
            firstName: firstName,
            lastName: lastName,
            userName: userName,
            email: email,
          ),
        );
      case Prechatscreen:
        return getPageRoute(
          settings: settings,
          view: PreChatScreen(),
        );
      case Viewrequestscreen:
        return getPageRoute(
          settings: settings,
          view: ViewRequestScreen(),
        );
      case RequestScreen:
        return getPageRoute(
          settings: settings,
          view: RequestsScreen(),
        );
      case MainChatscreen:
        return getPageRoute(
          settings: settings,
          view: MainChatScreen(),
        );
      case Addcardscreen:
        return getPageRoute(
          settings: settings,
          view: AddCardScreen(),
        );
      case Newpost:
        return getPageRoute(
          settings: settings,
          view: NewPostScreen(
            tag: settings.arguments.toString(),
          ),
        );
      case Recent:
        return getPageRoute(
          settings: settings,
          view: const RecentScreen(),
        );
      case LoginRoute:
        return getPageRoute(
          settings: settings,
          view: const Login(),
        );
      case SplashRoute:
        return getPageRoute(
          settings: settings,
          view: const SplashScreen(),
        );
      case VerifyPasswordRoute:
        return getPageRoute(
          settings: settings,
          view: VerifyAccount(email: settings.arguments.toString()),
        );
      case ForgotPasswordRoute:
        return getPageRoute(
          settings: settings,
          view: ForgotPassword(),
        );

      case ResetPasswordRoute:
        return getPageRoute(
          settings: settings,
          view: ResetPassword(email: settings.arguments.toString()),
        );
      case MainLayoutRoute:
        return getPageRoute(
          settings: settings,
          view: const MainLayoutPage(),
        );

      case ViewPrivateKeysRoute:
        return getPageRoute(
          settings: settings,
          view: ViewPrivateKeyScreen(),
        );

      case AddPrivateKeysRoute:
        return getPageRoute(
          settings: settings,
          view: VerifyPrivateKey(settings.arguments as UserModel),
        );
      case Profile:
        return getPageRoute(
          settings: settings,
          view: ProfileScreen(
            isPersonalProfile: settings.arguments as bool,
          ),
        );
      default:
        return getPageRoute(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute<dynamic> getPageRoute({
    required RouteSettings settings,
    required Widget view,
  }) {
    return Platform.isIOS
        ? CupertinoPageRoute(settings: settings, builder: (_) => view)
        : MaterialPageRoute(settings: settings, builder: (_) => view);
  }
}
