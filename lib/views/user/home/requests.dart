import '../../../core/models/request_list.dart';
import '../../widgets/__exports.dart';
import '../../widgets/request_widget.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final requestList = [
      RequestList(showAccept: false, showDecline: false),
      RequestList(showAccept: false, showDecline: false),
      RequestList(showAccept: false, showDecline: false),
      RequestList(showAccept: false, showDecline: false),
      //
      RequestList(showAccept: false, showDecline: true),
      RequestList(showAccept: true, showDecline: false),
      RequestList(showAccept: true, showDecline: false),
      RequestList(showAccept: false, showDecline: true),
      RequestList(showAccept: false, showDecline: false),
    ];
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
          onPressed: () {},
        ),
        title: RegularText(
          'Request',
          color: AppColors.darkGray,
          fontSize: 24.sp,
          height: 16.9 / 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: requestList.length,
                itemBuilder: (context, index) {
                  final item = requestList[index];
                  return ReqNotificationWidget(
                    showAccept: item.showAccept ?? true,
                    showDecline: item.showDecline ?? true,
                  );
                },
                separatorBuilder: (context, _) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Divider(
                      height: 0.5,
                      color: AppColors.darkGray.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
