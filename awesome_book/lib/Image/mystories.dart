class MyStories {
  late String id;
  late String storyURL;
  late String timeStamp;
  late String type;
  late String status;
  late String viewCount;
  late List<ViewerModel> viewersList = [];

  MyStories({
    required this.id,
    required this.storyURL,
    required this.timeStamp,
    required this.status,
    required this.type,
    required this.viewCount,
    required this.viewersList,
  });
}

class ViewerModel {
  late String id;
  late String name;
  late String imageURL;
  late String timeStamp;

  ViewerModel({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.timeStamp,
  });
}
