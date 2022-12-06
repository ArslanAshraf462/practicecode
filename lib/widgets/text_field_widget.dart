import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final TextInputType keyboard ;
  TextFieldWidget({required this.controller,required this.name,this.keyboard= TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboard,
      controller: controller,
      decoration: InputDecoration(hintText: name),
    );
  }
}
