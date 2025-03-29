import 'package:awesome_book/try2.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<Map<String, dynamic>> stories = [
    {"image": "assets/images/post1.jpg", "viewed": false},
    {"image": "assets/images/post1.jpg", "viewed": false},
    {"image": "assets/images/post1.jpg", "viewed": false},
  ];

  void openStory(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewer(
          stories: stories,
          currentIndex: index,
        ),
      ),
    );

    // Move viewed stories to the end
    setState(() {
      stories[index]["viewed"] = true;
      stories.add(stories.removeAt(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stories"), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(stories.length, (index) {
              return GestureDetector(
                onTap: () => openStory(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          stories[index]["viewed"] ? Colors.grey : Colors.red,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(stories[index]["image"]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
