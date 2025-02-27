class RequestModel {
  // String? receiverUid;
  String? senderUid;
  String? receiverUid;
  String? documentId;
  String? senderName;
  String? senderPhone;
  String? sentDate;
  String? sentTime;
  String? serviceRequired;
  String? serviceId;
  String? timeRequired;
  
  String? description;
  String? senderDeviceToken;
  double? senderLat;
  double? senderLong;
  String? senderProfileImage;
  String? senderAddress;
  String? distance;
  String? completed;
  String? status;
  String? mechanicProfile;
  String? mechanicName;
  String? vehicle;

  RequestModel({
    // this.receiverUid,
    this.documentId,
    this.serviceId,
    this.senderLat,
    this.senderLong,
    this.mechanicName,
    this.mechanicProfile,
    this.senderAddress,
    this.description,
    this.senderDeviceToken,
    this.senderUid,
    this.receiverUid,
    this.serviceRequired,
    this.senderName,
    this.vehicle,
    this.timeRequired,
    this.sentDate,
    this.sentTime,
    this.status,
    this.senderProfileImage,
    this.senderPhone,
    this.completed,
    this.distance,
  });

  Map<String, dynamic> toMap(RequestModel request) {
    var data = Map<String, dynamic>();
    // data['receiverUid'] = request.receiverUid;
    data['documentId'] = request.documentId;
    data['senderUid'] = request.senderUid;
    data['receiverUid'] = request.receiverUid;
    data['serviceRequired'] = request.serviceRequired;
    data['senderLat'] = request.senderLat;
    data['senderLong'] = request.senderLong;
    data['senderPhone'] = request.senderPhone;
    data['status'] = request.status;
    data['vehicle'] = request.vehicle;
    data['timeRequired'] = request.timeRequired;
    data['senderAddress'] = request.senderAddress;
    data['mechanicName'] = request.mechanicName;
    data['mechanicProfile'] = request.mechanicProfile;
    data['serviceId'] = request.serviceId;
    data['description'] = request.description;
    data['senderName'] = request.senderName;
    data['senderProfileImage'] = request.senderProfileImage;
    data['sentDate'] = request.sentDate;
    data['sentTime'] = request.sentTime;
    data['distance'] = request.distance;
    data['completed'] = request.completed;
    data['senderDeviceToken'] = request.senderDeviceToken;

    return data;
  }

  RequestModel.fromMap(Map<String, dynamic> mapData) {
    // receiverUid = mapData['receiverUid'];
    documentId = mapData['documentId'];
    serviceRequired = mapData['serviceRequired'];
    senderName = mapData['senderName'];
    senderUid = mapData['senderUid'];
    completed = mapData['completed'];
    description = mapData['description'];
    vehicle = mapData['vehicle'];
    receiverUid = mapData['receiverUid'];
    senderLat = mapData['senderLat'];
    senderLong = mapData['senderLong'];
    senderPhone = mapData['senderPhone'];
    senderAddress = mapData['senderAddress'];
    serviceId = mapData['serviceId'];
    timeRequired = mapData['timeRequired'];
    mechanicName = mapData['mechanicName'];
    mechanicProfile = mapData['mechanicProfile'];
    senderProfileImage = mapData['senderProfileImage'];
    sentDate = mapData['sentDate'];
    sentTime = mapData['sentTime'];
    distance = mapData['distance'];
    senderDeviceToken = mapData['senderDeviceToken'];
    status = mapData['status'];
  }
}
