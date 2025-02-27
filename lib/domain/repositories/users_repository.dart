
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../entities/seller_model.dart';
import '../entities/user_model.dart';

abstract class UsersRepository {
  Future<UserModel?> getUser();
  Future<User?> signUpUser(String email, String password,context);
  Future<User?> login(String email, String password,context);
  Future<void> saveUserDataToFirestore(UserModel userModel);
  Future<void> saveSellerDataToFirestore(SellerModel sellerModel);
  
  Future<String> uploadProfileImage(
      {required Uint8List? imageFile, required String uid});

  Future<SellerModel?> getSellerDetails();


}
