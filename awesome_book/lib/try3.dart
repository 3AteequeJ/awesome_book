// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pusher_client/pusher_client.dart';

// // Pusher Configuration
// const String PUSHER_APP_KEY = "YOUR_PUSHER_APP_KEY";
// const String PUSHER_APP_CLUSTER = "YOUR_PUSHER_APP_CLUSTER";
// const String BASE_URL = "http://127.0.0.1:8000/api"; // Your Laravel backend URL

// class ChatScreen extends StatefulWidget {
//   final int userId; // Current User ID
//   final int receiverId; // Chat Receiver ID

//   const ChatScreen({Key? key, required this.userId, required this.receiverId})
//       : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late PusherClient pusher;
//   late Channel channel;
//   TextEditingController messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     initializePusher();
//     fetchMessages();
//   }

//   // Initialize Pusher for real-time messaging
//   void initializePusher() {
//     pusher = PusherClient(
//       PUSHER_APP_KEY,
//       PusherOptions(cluster: PUSHER_APP_CLUSTER, encrypted: true),
//       autoConnect: true,
//     );

//     channel = pusher.subscribe("messages"); // Subscribe to Laravel channel

//     // Listen for new messages
//     channel.bind("MessageSent", (event) {
//       if (event?.data != null) {
//         var newMessage = jsonDecode(event!.data ?? '{}');
//         if (newMessage["receiver_id"] == widget.userId ||
//             newMessage["sender_id"] == widget.userId) {
//           setState(() {
//             messages.add(newMessage);
//           });
//         }
//       }
//     });
//   }

//   // Fetch previous messages
//   Future<void> fetchMessages() async {
//     var url = Uri.parse(
//         "$BASE_URL/get-messages?user_id=${widget.userId}&receiver_id=${widget.receiverId}");
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         messages = List<Map<String, dynamic>>.from(jsonDecode(response.body));
//       });
//     } else {
//       print("Failed to load messages: ${response.body}");
//     }
//   }

//   // Send message to Laravel API
//   Future<void> sendMessage() async {
//     String messageText = messageController.text.trim();
//     if (messageText.isEmpty) return;

//     var url = Uri.parse("$BASE_URL/send-message");
//     var response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "sender_id": widget.userId,
//         "receiver_id": widget.receiverId,
//         "message": messageText,
//       }),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         messages.add({
//           "sender_id": widget.userId,
//           "receiver_id": widget.receiverId,
//           "message": messageText,
//         });
//         messageController.clear();
//       });
//     } else {
//       print("Failed to send message: ${response.body}");
//     }
//   }

//   @override
//   void dispose() {
//     pusher.unsubscribe("messages");
//     pusher.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 var message = messages[index];
//                 bool isMe = message["sender_id"] == widget.userId;

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blue : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message["message"],
//                       style:
//                           TextStyle(color: isMe ? Colors.white : Colors.black),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(hintText: "Type a message..."),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
