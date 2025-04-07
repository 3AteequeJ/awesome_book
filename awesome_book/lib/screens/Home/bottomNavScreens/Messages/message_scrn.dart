import 'package:awesome_book/models/allMessagesList_model.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.userDetails,
  });

  final AllmessageslistModel userDetails;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [
    Message(
      sender: 'John',
      text: 'Hey, how are you doing?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
    ),
    Message(
      sender: 'Me',
      text: 'I\'m good, thanks for asking!',
      time: DateTime.now().subtract(const Duration(minutes: 4)),
      isMe: true,
    ),
    Message(
      sender: 'John',
      text: 'What are you up to this weekend?',
      time: DateTime.now().subtract(const Duration(minutes: 3)),
      isMe: false,
    ),
    Message(
      sender: 'Me',
      text: 'Not much, probably just relaxing at home. You?',
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      isMe: true,
    ),
    Message(
      sender: 'John',
      text: 'I\'m thinking of going hiking if the weather is nice.',
      time: DateTime.now().subtract(const Duration(minutes: 1)),
      isMe: false,
    ),
  ];

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(
        Message(
          sender: 'Me',
          text: text,
          time: DateTime.now(),
          isMe: true,
        ),
      );
    });
    // Simulate a response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              sender: 'John',
              text: 'That sounds interesting!',
              time: DateTime.now(),
              isMe: false,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(text: widget.userDetails.name),
        centerTitle: true,
        elevation: 1,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.userDetails.profile_image),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (_, int index) =>
                  _buildMessageItem(_messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe)
            CircleAvatar(
              child: Text(message.sender[0]),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Text(
                      message.sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  Text(message.text),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isMe)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Text(
                'M',
                style: TextStyle(color: Colors.white),
              ),
            ),
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

class Message {
  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  Message({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
