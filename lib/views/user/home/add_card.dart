import 'package:mms_app/core/navigation/navigator.dart';

import '../../widgets/__exports.dart';
import '../../widgets/card_field.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController emailController =
      TextEditingController(text: 'alma.lawson@example.com');
  TextEditingController name = TextEditingController(text: 'Wade Warren');
  TextEditingController cardNumber =
      TextEditingController(text: '6776  4553  3332  4992');
  TextEditingController expiryDate = TextEditingController(text: '12/25');
  TextEditingController cvv = TextEditingController(text: '977');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => AppNavigator.doPop()),
        title: RegularText(
          'Add card',
          color: AppColors.darkGray,
          fontSize: 24.sp,
          height: 16.9 / 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              'Card details',
              fontSize: 16.sp,
              height: 16.9 / 16,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
            16.verticalSpace,
            HeeboText(
              'Email',
              fontSize: 16.sp,
              height: 19 / 16,
              color: AppColors.gray,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CardFormField(
              controller: emailController,
              hintMessage: "Robert_22",
              validator: (a) {
                return Utils.isValidName(a, 'Username', 2);
              },
              onChanged: (a) {
                setState(() {});
              },
            ),
            24.verticalSpace,
            HeeboText(
              'Name on card',
              fontSize: 16.sp,
              height: 19 / 16,
              color: AppColors.gray,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CardFormField(
              controller: name,
              hintMessage: "Robert_22",
              validator: (a) {
                return Utils.isValidName(a, 'Username', 2);
              },
              onChanged: (a) {
                setState(() {});
              },
            ),
            24.verticalSpace,
            HeeboText(
              'Card Number',
              fontSize: 16.sp,
              height: 19 / 16,
              color: AppColors.gray,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 4.h),
            CardFormField(
              controller: cardNumber,
              hintMessage: "Robert_22",
              validator: (a) {
                return Utils.isValidName(a, 'Username', 2);
              },
              onChanged: (a) {
                setState(() {});
              },
            ),
            24.verticalSpace,
            Row(
              children: [
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    HeeboText(
                      'Expiry Date',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 4.h),
                    CardFormField(
                      width: 84.w,
                      controller: expiryDate,
                      hintMessage: "Robert_22",
                      validator: (a) {
                        return Utils.isValidName(a, 'Username', 2);
                      },
                      onChanged: (a) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(width: 24.w),
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    HeeboText(
                      'cvv',
                      fontSize: 16.sp,
                      height: 19 / 16,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 4.h),
                    CardFormField(
                      width: 60.w,
                      controller: cvv,
                      hintMessage: "Robert_22",
                      validator: (a) {
                        return Utils.isValidName(a, 'Username', 2);
                      },
                      onChanged: (a) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
