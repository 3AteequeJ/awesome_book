import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_book/widgets/mytext.dart';

class NativeAdWidget extends StatelessWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "Sponsored" label
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business,
                    color: Colors.blue,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Amazing Product Co.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Sponsored",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "2 hours ago",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    // Handle ad options (hide, report, etc.)
                    _showAdOptions(context);
                  },
                ),
              ],
            ),
          ),

          // Ad Caption/Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "🚀 Discover the future of technology! Transform your daily routine with our innovative solutions. Limited time offer - 50% off for new users!",
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Ad Image/Media
          Container(
            width: double.infinity,
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1560472355-536de3962603?w=500&h=400&fit=crop',
                ), // Replace with your ad image URL
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Overlay gradient for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Call-to-action overlay
                Positioned(
                  bottom: 3.h,
                  left: 3.w,
                  right: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Shop Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Interaction buttons (like posts)
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: "124",
                  onTap: () {
                    // Handle like action
                  },
                ),
                SizedBox(width: 6.w),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: "23",
                  onTap: () {
                    // Handle comment action
                  },
                ),
                SizedBox(width: 6.w),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: "Share",
                  onTap: () {
                    // Handle share action
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle CTA button tap - redirect to advertiser
                    _handleAdClick(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Learn More",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey.shade600,
            size: 5.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showAdOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility_off),
              title: Text("Hide this ad"),
              onTap: () {
                Navigator.pop(context);
                // Handle hide ad
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text("Report ad"),
              onTap: () {
                Navigator.pop(context);
                // Handle report ad
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Why am I seeing this ad?"),
              onTap: () {
                Navigator.pop(context);
                // Show ad targeting info
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAdClick(BuildContext context) {
    // Handle ad click - track engagement and redirect
    print("Ad clicked - tracking engagement");

    // You can add navigation to web view or external link here
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => WebView(url: "https://advertiser-website.com"),
    //   ),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Redirecting to advertiser..."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
