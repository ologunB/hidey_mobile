class FeedModel {
  String? userName;
  String? profileUrl;
  String? imageUrl;
  bool? isLocked;
  String? userBio;

  FeedModel({
    this.userName,
    this.imageUrl,
    this.isLocked = false,
    this.userBio,
    this.profileUrl,
  });
}
