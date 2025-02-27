import 'package:e_mech/data/models/provider_services.dart';

class TransactionModel{
// List<ProvidedServices>? services;
List<dynamic>? services;
String? mechanicId;
String? userId;
String? date;
String? time;
double? total;
  TransactionModel(
      {
        required this.services,
    required this.total,
      required this.mechanicId,
      required this.userId,
    required this.date,
    required this.time
    });
    
  Map<String, dynamic> toMap(TransactionModel user) {
    var data = Map<String, dynamic>();
    data['services'] = user.services;
    
    data['total'] = user.total;
    data['mechanicId'] = user.mechanicId;
    data['userId'] = user.userId;
    data['date'] = user.date;
    data['time'] = user.time;
    return data;
  }

  TransactionModel.fromMap(Map<String, dynamic> mapData) {
    services = mapData['services'];
    total = mapData['total'];
    mechanicId = mapData['mechanicId'];
    userId = mapData['userId'];
    date = mapData['date'];
    time = mapData['time'];
  
  }

}