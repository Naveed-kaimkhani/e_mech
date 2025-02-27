import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/seller_model.dart';
import '../domain/entities/user_model.dart';

class StorageService {
  static late SharedPreferences _sharedPreferences;

  static Future<void> saveUser(UserModel userModel) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
        'user', json.encode(userModel.toMap(userModel)));
  }
static Future<int?> checkUserInitialization() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int? isUser = preferences.getInt('isUser');
  return isUser;
}


static Future<int?> checkScreenInitialization()async{
  
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // await preferences.getInt('initScreen');
         return preferences.getInt('initScreen');
}
static Future<void> initUser()async{
  
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // await preferences.setInt('initScreen', 1);
          await preferences.setInt('isUser', 1);
}
  static Future<void> saveSeller(SellerModel sellerModel) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
        'seller', json.encode(sellerModel.toMap(sellerModel)));
  }
  static Future<UserModel?> readUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('user') == null
        ? null
        : UserModel.fromMap(
            json.decode(_sharedPreferences.getString('user')!));
  }

  static Future<SellerModel?> readSeller() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('seller') == null
        ? null
        : SellerModel.fromMap(
            json.decode(_sharedPreferences.getString('seller')!));
  }

  // static Future<List<SellerModel?>> readSellersData() async {
  //   _sharedPreferences = await SharedPreferences.getInstance();
  //   return _sharedPreferences.getString('AllSellersData') == null
  //       ? null
  //       : SellerModel.fromMap(
  //           json.decode(_sharedPreferences.getString('seller')!));
  // }

  static Future<void> clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}