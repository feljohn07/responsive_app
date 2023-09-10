import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:responsive_app/users_list/models/users_list_model.dart';
import 'package:responsive_app/users_list/repo/api_status.dart';
import 'package:responsive_app/utils/constants.dart';

class UserServices {
  static Future<Object> getUsers() async {
    try {
      var url = Uri.parse(USERS_LIST);
      var response = await http.get(url);
      
      if (response.statusCode == SUCCESS) {
        return Success(response: userListModelFromJson(response.body));
      }
      return Failure( code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
    } on HttpException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKOWN_ERROR, errorResponse: 'Unknow Error');
    }
  }
}
