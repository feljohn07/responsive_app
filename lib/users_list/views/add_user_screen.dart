import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/users_list/models/users_list_model.dart';
import 'package:responsive_app/users_list/view_models/users_view_model.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    UserModel? addUser = usersViewModel.addingUser;

    return Scaffold(
        appBar: AppBar(
          title: Text('Add User'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async  {
                bool userAdded = await usersViewModel.addUser();
                if(!userAdded){ 
                  return;
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  addUser?.name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  addUser?.email = value;
                },
              ),
              
            ],
          ),
        ),
      );
  }
}