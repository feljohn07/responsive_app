import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String errorTxt;
  const AppError({this.errorTxt = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: errorTxt.isNotEmpty,
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text(
                errorTxt,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
