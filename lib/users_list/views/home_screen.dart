import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/users_list/components/app_error.dart';
import 'package:responsive_app/users_list/components/app_loading.dart';
import 'package:responsive_app/users_list/components/user_list_row.dart';
import 'package:responsive_app/users_list/models/users_list_model.dart';
import 'package:responsive_app/users_list/view_models/users_view_model.dart';
import 'package:responsive_app/utils/navigation_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch();
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return usersViewModel.getUsers();
        },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_ui(usersViewModel)])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => openAddUser(context)),
    );
  }

  _ui(UsersViewModel usersViewModel) {
    if (usersViewModel.loading) {
      return AppLoading();
    }

    if (usersViewModel.userError != null) {
      return AppError(errorTxt: usersViewModel.userError!.message.toString());
    }

    return Expanded(
        child: ListView.builder(
      itemCount: usersViewModel.userListModel.length,
      itemBuilder: (context, index) {
        UserModel userModel = usersViewModel.userListModel[index];
        return UserListRow(
          userModel: userModel,
          onTap: () {
            print(userModel.toJson());
            usersViewModel.setSelectedUser(userModel);
            openUserDetails(context);
          },
        );
      },
    ));
  }
}
