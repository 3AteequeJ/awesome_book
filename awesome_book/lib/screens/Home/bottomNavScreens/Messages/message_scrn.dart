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
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreMessages = true;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

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

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    // Create a new message locally at the end
    final newMessage = Message_Model(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender_id: glb.userDetails.id,
      receiver_id: widget.userDetails.id,
      message: text.trim(),
      timestamp: DateTime.now().toString(),
    );

    setState(() {
      messages.add(newMessage);
    });

    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      Uri url = Uri.parse("https://awesomebook.in/awesomebookbackend/SendMsg");
      var res = await http.post(url, body: {
        "sender_id": glb.userDetails.id,
        "receiver_id": widget.userDetails.id,
        "message": text.trim(),
      });

      print("📩 Send Message API Status: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        getConvo_async();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send message")),
        );
      }
    } catch (e) {
      print("❌ Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending message")),
      );
    }
  }

  List<Message_Model> messages = [];
  @override
  void initState() {
    super.initState();
    getConvo_async();

    _scrollController.addListener(() {
      // when user reaches the TOP
      if (_scrollController.position.pixels <= 50 &&
          !isLoadingMore &&
          hasMoreMessages) {
        loadOlderMessages();
      }
    });
  }

  getConvo_async() async {
    messages.clear();
    currentPage = 1;
    hasMoreMessages = true;
    Uri url = Uri.parse(glb.API.getConvo);

    print("get convo == $url");

    try {
      var res = await http.post(url, body: {
        'sender_id': glb.userDetails.id,
        'receiver_id': widget.userDetails.id,
        'page': currentPage.toString(),
      });

      print("body ==> ${res.body}");
      print(
          "📡 Sending to getConvo: page=$currentPage, sender=${glb.userDetails.id}, receiver=${widget.userDetails.id}");
      print("📩 API Response (${res.statusCode}): ${res.body}");
      var bdy = jsonDecode(res.body);

      if (bdy.isEmpty) {
        hasMoreMessages = false;
        return;
      }

      bdy = bdy.reversed.toList();

      for (var message in bdy) {
        messages.add(Message_Model(
          id: message['id'].toString(),
          sender_id: message['sender_id'].toString(),
          receiver_id: message['receiver_id'].toString(),
          message: message['message'].toString(),
          timestamp: message['time_stamp'].toString(),
        ));
      }

      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print("❌ Error fetching conversation: $e");
    }
  }

  Future<void> loadOlderMessages() async {
    if (isLoadingMore || !hasMoreMessages) return;
    isLoadingMore = true;
    currentPage++;

    print("⬆️ Loading older messages (page $currentPage)");

    try {
      Uri url = Uri.parse(glb.API.getConvo);
      var res = await http.post(url, body: {
        'sender_id': glb.userDetails.id,
        'receiver_id': widget.userDetails.id,
        'page': currentPage.toString(),
      });

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        var bdy = jsonDecode(res.body);

        if (bdy.isEmpty) {
          print("⛔ No more messages");
          hasMoreMessages = false;
          isLoadingMore = false;
          return;
        }

        bdy = bdy.reversed.toList();

        // ✅ Convert raw data into a list of Message_Model
        List<Message_Model> olderMessages = bdy.map<Message_Model>((msg) {
          return Message_Model(
            id: msg['id'].toString(),
            sender_id: msg['sender_id'].toString(),
            receiver_id: msg['receiver_id'].toString(),
            message: msg['message'].toString(),
            timestamp: msg['time_stamp'].toString(),
          );
        }).toList();

        double beforeOffset = _scrollController.offset;
        double beforeMaxExtent = _scrollController.position.maxScrollExtent;

        setState(() {
          messages.insertAll(0, olderMessages);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            double newMaxExtent = _scrollController.position.maxScrollExtent;
            double offsetDiff = newMaxExtent - beforeMaxExtent;
            _scrollController.jumpTo(beforeOffset + offsetDiff);
          }
        });
      } else {
        print("❌ Failed loading older messages: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Error loading older messages: $e");
    }

    isLoadingMore = false;
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
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              reverse: false, // keep normal order (top -> old, bottom -> new)
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
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
