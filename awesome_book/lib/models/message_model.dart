class Message_Model {
  late String id;
  late String sender_id;
  late String receiver_id;
  late String message;
  late String timestamp;

  Message_Model({
    required this.id,
    required this.sender_id,
    required this.receiver_id,
    required this.message,
    required this.timestamp,
  });
}
