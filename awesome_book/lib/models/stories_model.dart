class StoryUser {
  final String user_id;
  final String username;
  final String userImage;
  final List<Story> stories;

  StoryUser({
    required this.user_id,
    required this.username,
    required this.userImage,
    required this.stories,
  });
}

class Story {
  final String storyId;
  final String imageUrl;
  final String timeAgo;
  final String storyType; // 'image' or 'video'
  String viewed;

  Story({
    required this.storyId,
    required this.storyType,
    required this.viewed,
    required this.imageUrl,
    required this.timeAgo,
  });
}
