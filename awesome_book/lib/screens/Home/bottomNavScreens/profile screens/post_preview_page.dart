import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPreviewPage extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostPreviewPage({super.key, required this.post});

  @override
  State<PostPreviewPage> createState() => _PostPreviewPageState();
}

class _PostPreviewPageState extends State<PostPreviewPage> {
  bool _isDeleting = false;

  /// ✅ Normalize inconsistent backend image paths
  String _fixImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    if (raw.startsWith("http")) return raw;
    if (raw.startsWith("/images/")) {
      return "https://awesomebook.in/awesomebookbackend/public$raw";
    } else if (raw.startsWith("public/")) {
      return "https://awesomebook.in/awesomebookbackend/$raw";
    } else {
      return "https://awesomebook.in/awesomebookbackend/public/$raw";
    }
  }

  Future<void> _deletePost() async {
    final postId = widget.post["id"]?.toString() ??
        widget.post["post_id"]?.toString() ??
        "";

    if (postId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Post ID")),
      );
      return;
    }

    setState(() => _isDeleting = true);

    try {
      final url = Uri.parse(
          "https://awesomebook.in/awesomebookbackend/admin_deletePost");

      // ✅ Correct method: DELETE (not POST)
      final res = await http.delete(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"post_id": postId},
      );

      print("🗑 DELETE Response: ${res.statusCode} ${res.body}");

      // ✅ Clean up HTML output just in case
      final clean = res.body.replaceAll(RegExp(r'<[^>]*>'), '').trim();

      if (res.statusCode == 200 &&
          (clean.contains("1") || clean.toLowerCase().contains("success"))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Post deleted successfully")),
        );
        Navigator.pop(context, true); // refresh profile screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to delete post: $clean")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Delete Post",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to delete this post permanently?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rawImage = (widget.post["p_name"] ??
            widget.post["image"] ??
            widget.post["post_image"] ??
            widget.post["img"] ??
            "")
        .toString();

    final String caption =
        (widget.post["caption"] ?? "").toString().trim().isEmpty
            ? ""
            : widget.post["caption"].toString();

    final String username = (widget.post["user_name"] ?? "Unknown").toString();

    final String profileImg = _fixImageUrl(widget.post["profile_image"]);
    final String imageUrl = _fixImageUrl(rawImage);
    final String likes = widget.post["like_count"]?.toString() ?? "0";
    final String comments = widget.post["comment_count"]?.toString() ?? "0";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: profileImg.isNotEmpty
                  ? NetworkImage(profileImg)
                  : const AssetImage('assets/images/post1.jpg')
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(username,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
            const SizedBox(width: 5),
            const Icon(Icons.verified, color: Colors.blue, size: 18),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "delete") _confirmDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Delete"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: InteractiveViewer(
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : const Icon(Icons.broken_image,
                            color: Colors.white, size: 50),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_border,
                            color: Colors.black, size: 26),
                        const SizedBox(width: 12),
                        Icon(Icons.mode_comment_outlined,
                            color: Colors.black, size: 26),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$likes likes • $comments comments",
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    if (caption.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        caption,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
