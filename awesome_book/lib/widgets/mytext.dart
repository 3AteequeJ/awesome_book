import 'package:flutter/material.dart';

class Txt extends StatefulWidget {
  const Txt({
    super.key,
    required this.text,
    this.fntWt = FontWeight.normal,
    this.fntSz = 16,
    this.colour = Colors.black,
  });
  final String text;
  final FontWeight fntWt;
  final double fntSz;
  final Color colour;
  @override
  State<Txt> createState() => _TxtState();
}

class _TxtState extends State<Txt> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: widget.fntWt,
          fontSize: widget.fntSz,
          color: widget.colour),
    );
  }
}
