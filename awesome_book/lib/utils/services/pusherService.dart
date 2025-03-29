// import 'package:pusher_client/pusher_client.dart';

// class PusherService {
//   late PusherClient pusher;
//   late Channel channel;

//   PusherService() {
//     pusher = PusherClient(
//       "e79fd8276f3a10d424a9", // Replace with your Pusher App Key
//       PusherOptions(
//         cluster: "ap2", // Replace with your Pusher Cluster
//         encrypted: true,
//       ),
//       autoConnect: true,
//     );

//     channel = pusher.subscribe("messages"); // Subscribe to the Laravel channel
//   }

//   void listenToMessages(Function(dynamic) callback) {
//     channel.bind("MessageSent", (event) {
//       callback(event?.data);
//     });
//   }

//   void disconnect() {
//     pusher.unsubscribe("messages");
//     pusher.disconnect();
//   }
// }
