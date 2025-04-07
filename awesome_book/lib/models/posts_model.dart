class Post_model {
  late String id;
  late String name;
  late String user_name;
  late String profileImage;
  late String isFollowing;
  late String type;
  late String caption;
  late String dateTime;
  late String no_likes;
  late String is_liked;
  late String no_comments;
  late String verified;

  Post_model({
    required this.id,
    required this.name,
    required this.user_name,
    required this.profileImage,
    required this.verified,
    required this.type,
    required this.caption,
    required this.dateTime,
    required this.no_likes,
    required this.no_comments,
    required this.isFollowing,
    required this.is_liked,
  });
}
