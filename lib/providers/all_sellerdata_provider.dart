
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';

import '../data/firebase_user_repository.dart';
import '../domain/entities/seller_model.dart';
class AllSellerDataProvider with ChangeNotifier {
  List<SellerModel>? _sellersData;
  List<SellerModel>? get sellers => _sellersData;

  Future getSellersDataFromServer(context) async {
    final FirebaseUserRepository firebaseRepository = FirebaseUserRepository();
    _sellersData = await firebaseRepository.getSellersData();
    if (_sellersData == null) {
      utils.flushBarErrorMessage("No seller found",context);
    }
    notifyListeners();
  }
}
