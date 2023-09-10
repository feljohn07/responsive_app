import 'package:flutter/material.dart';
import 'package:responsive_app/users_list/models/user_error.dart';
import 'package:responsive_app/users_list/models/users_list_model.dart';
import 'package:responsive_app/users_list/repo/api_status.dart';
import 'package:responsive_app/users_list/repo/user_services.dart';

class UsersViewModel extends ChangeNotifier {
  bool _loading = false;
  List<UserModel> _userListModel = [];
  UserError? _userError;
  UserModel? _selectedUser;
  UserModel? _addingUser = UserModel();

  bool get loading => _loading;
  List<UserModel> get userListModel => _userListModel;
  UserError? get userError => _userError;
  UserModel? get selectedUser => _selectedUser;
  UserModel? get addingUser => _addingUser;

  UsersViewModel() {
    print('userviewModel');
    getUsers();
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setUserListModel(List<UserModel> userListModel) async {
    _userListModel = userListModel;
  }

  setUserError(UserError userError) async {
    _userError = userError;
  }

  setSelectedUser(UserModel userModel) {
    _selectedUser = userModel;
    notifyListeners();
  }
  
  setAddingUser(UserModel userModel) {
    _addingUser = userModel;
    notifyListeners();
  }

  addUser () {
    if(!isValid()){
      return false;
    }

    _userListModel.add(addingUser!);
    _addingUser = UserModel();
    notifyListeners(); 

    return true;
  }

  isValid () {
    if (addingUser?.name == null || addingUser?.name == '') {
      return false;
    }
    if (addingUser?.email == null || addingUser?.email == '') {
      return false;
    }
    return true;
  }

  getUsers() async {
    setLoading(true);
    final response = await UserServices.getUsers();
    if (response is Success) {
      setUserListModel(response.response as List<UserModel>);
    }
    if (response is Failure) {
      setUserError(
        UserError(
          code: response.code,
          message: response.errorResponse,
        ),
      );
    }
    setLoading(false);
  }

  UserModel? getUser() {
    return _selectedUser;
  }
}
