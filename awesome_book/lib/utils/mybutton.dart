import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.required_widget,
    required this.on_tap,
    this.foregroundColor = Colors.white,
    this.wdt = double.infinity,
    this.borderRadius = 10,
  });
  final Widget required_widget;
  final Function on_tap;
  final Color foregroundColor;
  final double wdt;
  final double borderRadius;
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.sp),
      ),
      color: Colors.transparent,
      shadowColor: Colors.purple,
      child: Container(
        height: 50,
        width: widget.wdt,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius.sp),
          gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffB6D0F2),
                Color(0xff91AAF2),
                Color(0xff798BF2),
                Color(0xff667BF2),
                Color(0xff798BF2),
                Color(0xff91AAF2),
                Color(0xffB6D0F2),
              ]),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/bg_gradient.jpeg"),
          ),
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              splashFactory: InkRipple.splashFactory,
              backgroundColor: Colors.transparent,
              foregroundColor: widget.foregroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              widget.on_tap();
            },
            child: widget.required_widget),
      ),
    );
  }
}
