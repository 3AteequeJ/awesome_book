import 'package:awesome_book/utils/colours.dart';
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
      ),
      borderRadius: BorderRadius.circular(12),
    );

    final FocusedBorder = OutlineInputBorder(
      borderSide:
          Divider.createBorderSide(context, width: 2, color: Colours.brown),
      borderRadius: BorderRadius.circular(12),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: FocusedBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: Colors.white.withOpacity(.5),
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
