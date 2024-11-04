import '../models/feed_model.dart';
import '../models/user_story.model.dart';

final List<StoryModel> chatList = [
  StoryModel(name: 'Casey_jones', imagePath: 'user_image', text: 'Hi babe 💓'),
  StoryModel(
      name: 'Quincey Roland', imagePath: 'profile', text: 'What you up to?'),
  StoryModel(
      name: 'Cameron Williamson', imagePath: 'user_image', text: 'Hello dear'),
  StoryModel(name: 'Quincey Roland', imagePath: 'profile', text: 'Hi dear'),
  StoryModel(name: 'Tohsin', imagePath: 'user_image', text: 'Wey my money'),
];

final List<String> people = [
  'Quincy Roland',
  'Cameron Williamson',
  'Quincey Roland'
];

//HOME
List<StoryModel> usersStory = [
  StoryModel(name: 'Tohsin', imagePath: 'profile'),
  StoryModel(name: 'Tohsin', imagePath: 'user_image'),
  StoryModel(name: 'Tohsin', imagePath: 'profile'),
  StoryModel(name: 'Tohsin', imagePath: 'user_image'),
  StoryModel(name: 'Tohsin', imagePath: 'profile'),
  StoryModel(name: 'Tohsin', imagePath: 'user_image'),
];
List<FeedModel> feedList = [
  FeedModel(
    userName: 'Quincey Roland',
    profileUrl: 'user_image',
    imageUrl: 'assets/images/feed_image.png',
    userBio:
        '''Chasing my dreams and living my best life! 🌟' \n #blessed #grateful #nevergiveup''',
  ),
  FeedModel(
    userName: 'Cameron Williamson',
    profileUrl: 'profile',
    imageUrl: 'assets/images/feed_image_2.png',
    userBio:
        '''Inspired by music, driven by passion, and expressing my soul through ballet 🎶✨''',
  ),
  FeedModel(
      userName: 'Jenny Wilson',
      profileUrl: 'user_image',
      imageUrl: 'assets/images/feed_image.png',
      isLocked: true,
      userBio:
          '''Dive into a realm of seduction and intimacy, click the button below to unlock the post for just \$5'''),
  FeedModel(
    userName: 'Savannah Nguyen',
    profileUrl: 'profile',
    imageUrl: 'assets/images/feed_image_2.png',
    userBio:
        '''Stepping into my power, unapologetically sexy 💃🔥 subscribe to my page for exclusive content''',
  ),
];
