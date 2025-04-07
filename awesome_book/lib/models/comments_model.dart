class CommentsModel {
  late String id;
  late String post_id;
  late String user_id;
  late String user_name;
  late String user_img;
  late String date_time;
  late String comment;

  CommentsModel({
    required this.id,
    required this.user_id,
    required this.user_name,
    required this.user_img,
    required this.post_id,
    required this.date_time,
    required this.comment,
  });
}
