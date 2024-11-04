import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../core/apis/encryption_tool.dart';
import '../widgets/back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/snackbar.dart';
import '../widgets/text_widgets.dart';
import 'download_private_key.dart';

class ViewPrivateKeyScreen extends StatefulWidget {
  @override
  State<ViewPrivateKeyScreen> createState() => _ViewPrivateKeyScreenState();
}

class _ViewPrivateKeyScreenState extends State<ViewPrivateKeyScreen> {
  @override
  Widget build(BuildContext context) {
    String key = EncryptionTool.readKey()!;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: RegularText(
          'Private Key',
          color: const Color(0xff000000),
          fontSize: 24.h,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xffF5F5F5),
        leading: HideyBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          children: [
            PrettyQr(
              data: key,
              errorCorrectLevel: QrErrorCorrectLevel.Q,
              roundEdges: true,
              image: AssetImage('assets/images/logo.png'),
              size: 260.h,
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: RegularText(
                key,
                fontSize: 16.sp,
                color: const Color(0xff1A1A1A),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 78.h),
            GeneralButton(
              text: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: key));
                showSnackBar(
                  context,
                  null,
                  'Your Private key has been  copied to your clipboard!',
                  color: AppColors.primaryColor,
                );
              },
              primColor: AppColors.primaryColor,
              textColor: const Color(0xffFFFFFF),
              borderColor: AppColors.primaryColor,
            ),
            SizedBox(height: 16.h),
            GeneralButton(
              text: 'Download',
              onPressed: () {
                shareSeedQRScan(key);
              },
              primColor: const Color(0xffEFEFEF),
              textColor: AppColors.primaryColor,
              borderColor: const Color(0xffEFEFEF),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareSeedQRScan(String seed) async {
    generateReceipt(EncryptionTool.applicationDocuments.path, seed);
  }
}
