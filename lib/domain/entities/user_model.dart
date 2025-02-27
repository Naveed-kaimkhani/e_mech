class UserModel {
  String? uid;
  String? profileImage;
  String? name;
  double? lat;
  double? long;
  String? address;
  String? phone;
  String? email;
  String? gender;
  String? deviceToken;
  String? lastActive;
  bool? isOnline;

  UserModel(
      {required this.uid,
      required this.profileImage,
      required this.name,
      required this.phone,
      this.lat,
      this.long,
      required this.email,
      required this.gender,
      required this.deviceToken,
      required this.lastActive,
      required this.isOnline});

  Map<String, dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['lat'] = user.lat;
    data['long'] = user.long;
    data['address'] = user.address;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['gender'] = user.gender;
    data['deviceToken'] = user.deviceToken;
    data['lastActive'] = user.lastActive;
    data['isOnline'] = user.isOnline;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    lat = mapData['lat'];
    long = mapData['long'];
    address = mapData['address'];
    phone = mapData['phone'];
    email = mapData['email'];
    gender = mapData['gender'];
    deviceToken = mapData['deviceToken'];
    lastActive = mapData['lastActive'];
    isOnline = mapData['isOnline'];
  }
}
