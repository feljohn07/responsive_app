import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/users_list/components/app_title.dart';
import 'package:responsive_app/users_list/models/users_list_model.dart';
import 'package:responsive_app/users_list/view_models/users_view_model.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    UserModel user = usersViewModel.getUser()!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.name!),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserName(title: user.name!),
            Text(user.email!)
          ],
        ),
      ),
    );
  }
}
