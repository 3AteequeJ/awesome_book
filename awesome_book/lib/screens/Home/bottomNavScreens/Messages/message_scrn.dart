import 'dart:convert';

import 'package:awesome_book/models/allMessagesList_model.dart';
import 'package:awesome_book/models/message_model.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;

class MessageScreen extends StatefulWidget {
  MessageScreen({
    super.key,
    required this.userDetails,
  });

  final AllmessageslistModel userDetails;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textController = TextEditingController();
  // final List<Message> _messages = [
  //   Message(
  //     sender: 'John',
  //     text: 'Hey, how are you doing?',
  //     time: DateTime.now().subtract(const Duration(minutes: 5)),
  //     isMe: false,
  //   ),
  //   Message(
  //     sender: 'Me',
  //     text: 'I\'m good, thanks for asking!',
  //     time: DateTime.now().subtract(const Duration(minutes: 4)),
  //     isMe: true,
  //   ),
  //   Message(
  //     sender: 'John',
  //     text: 'What are you up to this weekend?',
  //     time: DateTime.now().subtract(const Duration(minutes: 3)),
  //     isMe: false,
  //   ),
  //   Message(
  //     sender: 'Me',
  //     text: 'Not much, probably just relaxing at home. You?',
  //     time: DateTime.now().subtract(const Duration(minutes: 2)),
  //     isMe: true,
  //   ),
  //   Message(
  //     sender: 'John',
  //     text: 'I\'m thinking of going hiking if the weather is nice.',
  //     time: DateTime.now().subtract(const Duration(minutes: 1)),
  //     isMe: false,
  //   ),
  // ];

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      // _messages.add(
      //   Message(
      //     sender: 'Me',
      //     text: text,
      //     time: DateTime.now(),
      //     isMe: true,
      //   ),
      // );
    });
    // Simulate a response after 1 second
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (mounted) {
    //     setState(() {
    //       _messages.add(
    //         Message(
    //           sender: 'John',
    //           text: 'That sounds interesting!',
    //           time: DateTime.now(),
    //           isMe: false,
    //         ),
    //       );
    //     });
    //   }
    // });
  }

  List<Message_Model> messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConvo_async();
  }

  getConvo_async() async {
    messages.clear();
    Uri url = Uri.parse(glb.API.getConvo);

    try {
      var res = await http.post(url, body: {
        'sender_id': glb.userDetails.id,
        'receiver_id': widget.userDetails.id,
      });

      print(res.body);
      List b = jsonDecode(res.body);
      var bdy = jsonDecode(res.body);

      for (var message in bdy) {
        print("this is message: ${message}");
        messages.add(Message_Model(
          id: message['id'].toString(),
          sender_id: message['sender_id'].toString(),
          receiver_id: message['receiver_id'].toString(),
          message: message['message'].toString(),
          timestamp: message['time_stamp'].toString(),
        ));
      }

      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(text: widget.userDetails.name),
        centerTitle: true,
        elevation: 1,
        actions: [
          InkWell(
            onTap: () {
              getConvo_async();
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.userDetails.profile_image),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (_, int index) => _buildMessageItem(messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message_Model message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: message.sender_id == glb.userDetails.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // if (!message.sender_id == glb.userDetails.id)
          //   CircleAvatar(
          //     child: Text(message.sender[0]),
          //   ),
          SizedBox(width: 8.sp),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.sender_id == glb.userDetails.id
                    ? Colors.blue[100]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.message),
                  SizedBox(height: 4.sp),
                  Text(
                    glb.getDuration(message.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.sp),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Send a message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
