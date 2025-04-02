class StoryUser {
  final String username;
  final String userImage;
  final List<Story> stories;

  StoryUser({
    required this.username,
    required this.userImage,
    required this.stories,
  });
}

class Story {
  final String imageUrl;
  final String timeAgo;

  Story({
    required this.imageUrl,
    required this.timeAgo,
  });
}
