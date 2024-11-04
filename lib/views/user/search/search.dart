import '../../../core/navigation/navigator.dart';
import '../../widgets/__exports.dart';
import '../../widgets/search_chat.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> people = [
    'Quincy Roland',
    'Cameron Williamson',
    'Quincey Roland'
  ];
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
          onPressed: () {},
        ),
        title: RegularText(
          'New Chat',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: SearchFormField(
                      hintMessage: 'Search',
                      typeOfInput: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: people.length,
                itemBuilder: (context, index) {
                  return SearchChatWidget(
                    name: people[index],
                    onTapChat: () => AppNavigator.navigateTo(MainChatscreen),
                    onTapProfile: () =>
                        AppNavigator.navigateTo(Profile, arguments: false),
                  );
                },
                separatorBuilder: (context, _) {
                  return SizedBox(height: 8);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
