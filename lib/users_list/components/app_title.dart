import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  final String title;
  UserName({this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
