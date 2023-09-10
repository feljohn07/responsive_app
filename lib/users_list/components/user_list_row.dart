import 'package:flutter/material.dart';
import 'package:responsive_app/users_list/components/app_title.dart';
import 'package:responsive_app/users_list/models/users_list_model.dart';

class UserListRow extends StatelessWidget {
  final UserModel userModel;
  final Function onTap;

  const UserListRow({required this.userModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: ListTile(
        title: UserName(title: userModel.name!),
        subtitle: Text(userModel.email!),
      ),
    );
  }
}
