import 'dart:convert';

import 'package:mms_app/core/apis/encryption_tool.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:sodium_libs/sodium_libs.dart';

import '../../locator.dart';
import '../../views/widgets/colors.dart';
import '../../views/widgets/snackbar.dart';
import '../apis/auth_api.dart';
import '../models/user_model.dart';
import '../navigation/navigator.dart';
import '../utils/custom_exception.dart';
import 'base_vm.dart';

class AuthViewModel extends BaseModel {
  final AuthApi _authApi = locator<AuthApi>();
  String? error;

  Future<List?> signup(Map<String, dynamic> a) async {
    setBusy(true);
    try {
      dynamic res = await _authApi.signup(a);
      if (res is List) {
        showDialog(
            'Username has been chosen, change or choose from the below list');
        setBusy(false);
        return res.toSet().toList();
      }
      AppNavigator.navigateToAndReplace(
        VerifyPasswordRoute,
        arguments: a['Email'],
      );
      showDialog('Verify your account', res);
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
    }
    return null;
  }

  Future<void> login(Map<String, dynamic> a) async {
    setBusy(true);
    try {
      UserModel model = await _authApi.login(a);
      await AppCache.setToken(model.token!);
      await AppCache.setUser(model.user!);
      String? privateKey = EncryptionTool.readKey();
      if (model.user!.publicKey!.length < 20) {
        KeyPair keyPair = EncryptionTool.generatePair();
        String pubKey = base64Encode(keyPair.publicKey);
        await updateProfile({'PublicKey': pubKey});
        EncryptionTool.savePrivateKey(
            base64Encode(keyPair.secretKey.extractBytes()));
        User updated = model.user!;
        updated.publicKey = pubKey;
        await AppCache.setUser(updated);

        AppNavigator.navigateToAndReplace(MainLayoutRoute);
        AppNavigator.navigateTo(ViewPrivateKeysRoute);
      } else if (privateKey == null) {
        AppCache.clear();
        AppNavigator.navigateTo(AddPrivateKeysRoute, arguments: model);
      } else {
        AppNavigator.navigateToAndReplace(MainLayoutRoute);
      }

      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
      if (error == 'Account not Verified') {
        AppNavigator.navigateTo(
          VerifyPasswordRoute,
          arguments: a['Email'],
        );
      }
    }
  }

  void completeLogin(UserModel model, String secretKey) async {
    bool value =
        EncryptionTool.shitTestKeyPair(model.user!.publicKey!, secretKey);
    if (value) {
      await AppCache.setUser(model.user!);
      await AppCache.setToken(model.token!);
      await EncryptionTool.savePrivateKey(secretKey);
      AppNavigator.navigateToAndReplace(MainLayoutRoute);
    } else {
      showDialog('The Secret Key is not correct');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> a) async {
    setBusy(true);
    try {
      await _authApi.updateProfile(a);
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
    }
  }

  Future<void> verify(Map<String, dynamic> a) async {
    setBusy(true);
    try {
      await _authApi.verify(a);
      AppNavigator.navigateToAndClear(LoginRoute);
      showDialog('Account has been verified, you can login now', 'Success');
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
    }
  }

  Future<void> generateResetPassword(Map<String, dynamic> a,
      {bool navigate = true}) async {
    setBusy(true);
    try {
      String res = await _authApi.generateResetPassword(a);
      setBusy(false);
      if (navigate)
        AppNavigator.navigateToAndReplace(
          ResetPasswordRoute,
          arguments: a['Email'],
        );
      showDialog(
          'A code has been sent to your email, enter here your account', res);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
    }
  }

  Future<void> resetPassword(Map<String, dynamic> a) async {
    setBusy(true);
    try {
      String token = await _authApi.resetPassword(a);
      await AppNavigator.navigateToAndReplace(MainLayoutRoute);
      await AppCache.setToken(token);
      showDialog(
          'Your password has been changed, you are logged in now', 'Success');
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e.message);
    }
  }

  void showDialog(String e, [String? title]) {
    showSnackBar(
      AppNavigator.navKey.currentContext!,
      title ?? 'Error',
      e.toTitleCase(),
      color: title == null ? AppColors.red : AppColors.primaryColor,
    );
  }
}
