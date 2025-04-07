import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';

class Activities_scrn extends StatefulWidget {
  const Activities_scrn({super.key});

  @override
  State<Activities_scrn> createState() => _Activities_scrnState();
}

class _Activities_scrnState extends State<Activities_scrn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Txt(text: "Activities"),
    );
  }
}
