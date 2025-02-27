import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mech/data/models/transaction.dart';
import 'package:e_mech/data/notification_services.dart';
import 'package:e_mech/providers/user_provider.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../domain/entities/request_model.dart';
import '../domain/entities/seller_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/users_repository.dart';
import '../providers/all_sellerdata_provider.dart';
import '../providers/seller_provider.dart';

class FirebaseUserRepository implements UsersRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection =
      firestore.collection('users');
  static final CollectionReference _transactionCollection =
      firestore.collection('transactions');
  static final CollectionReference _sellerCollection =
      firestore.collection('sellers');
  final Reference _storageReference = FirebaseStorage.instance.ref();
  NotificationServices _notificationServices = NotificationServices();
  Future<User?> login(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      utils.flushBarErrorMessage("Invalid email or password", context);
    }
  }

  @override
  Future<UserModel?> getUser() async {
    // var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    // var response = await http.get(url);
    // var list = jsonDecode(response.body) as List;
    // return list.map((e) => UserJson.fromJson(e).toDomain()).toList();
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      UserModel? userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<SellerModel?> getSeller() async {
    DocumentSnapshot documentSnapshot =
        await _sellerCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      SellerModel? sellerModel =
          SellerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      if (sellerModel != null) {
        return sellerModel;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Future<User?> signUpUser(String email, String password, context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      utils.flushBarErrorMessage(error.message.toString(), context);
    }
    return null;
  }

  @override
  Future<void> saveUserDataToFirestore(UserModel userModel) async {
    await _userCollection.doc(userModel.uid).set(userModel.toMap(userModel));
  }

  @override
  Future<void> saveSellerDataToFirestore(SellerModel sellerModel) async {
    await _sellerCollection
        .doc(sellerModel.uid)
        .set(sellerModel.toMap(sellerModel));
  }

  @override
  Future<String> uploadProfileImage(
      {required Uint8List? imageFile, required String uid}) async {
    await _storageReference
        .child('profile_images')
        .child(uid)
        .putData(imageFile!);
    String downloadURL =
        await _storageReference.child('profile_images/$uid').getDownloadURL();
    return downloadURL;
  }

  @override
  Future<SellerModel?> getSellerDetails() async {
    DocumentSnapshot documentSnapshot =
        await _sellerCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      SellerModel seller =
          SellerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      return seller;
    }
    return null;
  }

  @override
  Future<SellerModel?> getSellerDetailsUsingID(String uid) async {
    DocumentSnapshot documentSnapshot = await _sellerCollection.doc(uid).get();
    if (documentSnapshot.data() != null) {
      SellerModel seller =
          SellerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      return seller;
    }
    return null;
  }

  static Future<void> saveTransactionDataToFirestore(
      TransactionModel transaction) async {
    await _transactionCollection.add(transaction.toMap(transaction));
  }

  static Future<void> acceptRequest(
      RequestModel requestModel, String timeRequired, context) async {
    try {
      final DocumentReference requestRef = await _sellerCollection
          .doc(utils.currentUserUid)
          .collection('AcceptedRequest')
          .add(requestModel.toMap(requestModel));

      final String documentId = requestRef.id;
      await requestRef
          .update({'documentId': documentId, 'timeRequired': timeRequired});
      // await deleteRequestFromEverySeller(requestModel.serviceId!, context);

      deleteRequestDocument("Request", requestModel.documentId!, context);
      // Show success message or perform other operations
      // utils.toastMessage("Request Accepted");
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
      // Handle error
    }
  }

  static Future<void> updateRequestStatus(
      RequestModel requestModel, context) async {
    try {
      final DocumentReference requestRef = await _sellerCollection
          .doc(requestModel.receiverUid)
          .collection('AcceptedRequest')
          .doc(requestModel.documentId);

      final String documentId = requestRef.id;
      await requestRef.update({
        'status': 'accepted',
      });
      // await deleteRequestFromEverySeller(requestModel.serviceId!, context);
      utils.toastMessage("Request Accepted.");
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
      // Handle error
    }
  }

  static Future<void> markRequestCompletedFromUserSide(
      RequestModel requestModel, context) async {
    try {
      final DocumentReference requestRef = await _sellerCollection
          .doc(requestModel.receiverUid)
          .collection('AcceptedRequest')
          .doc(requestModel.documentId);

      final String documentId = requestRef.id;
      await requestRef.update({
        'completed': 'completed',
      });
      // await deleteRequestFromEverySeller(requestModel.serviceId!, context);
      utils.toastMessage("Service Completed.");
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
      // Handle error
    }
  }

  static Future<void> addRatingToMechanicProfile(
      RequestModel requestModel, double rating, context) async {
    try {
      final DocumentReference sellerDocRef =
          await _sellerCollection.doc(requestModel.receiverUid);

      await sellerDocRef
          .update({'rating': rating, 'nor': FieldValue.increment(1)});

      // await deleteRequestFromEverySeller(requestModel.serviceId!, context);
      utils.toastMessage("Rating added.");
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
      // Handle error
    }
  }

  static Future<void> deleteRequest(RequestModel requestModel, context) async {
    try {
      // final DocumentReference requestRef =
      await _sellerCollection
          .doc(requestModel.receiverUid)
          .collection('AcceptedRequest')
          .doc(requestModel.documentId)
          .delete();
      utils.toastMessage("Request Deleted.");
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
      // Handle error
    }
  }

  Future<void> addlatLongToFirebaseDocument(
    double lat,
    double long,
    String address,
    String? refreshedToken,
    String documentName,
  ) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection(documentName)
          .doc(utils.currentUserUid);

      if (refreshedToken == null) {
        await userRef.update({
          'lat': lat,
          'long': long,
          'address': address,
        });
      } else {
        await userRef.update({
          'lat': lat,
          'long': long,
          'address': address,
          'deviceToken': refreshedToken,
        });
      }
    } catch (e) {
      utils.toastMessage(e.toString());
    }
  }

  Future<List<SellerModel>> getSellersData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("sellers").get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return SellerModel.fromMap(data);
    }).toList();
  }

  static Future<void> sentRequest(
    List<SellerModel> sellers,
    RequestModel requestModel,
    context,
  ) async {
    try {
      int i = 0;
      int total = 0;
      for (SellerModel seller in sellers) {
        total++;
        double distance = utils.getDistancebtwRiderNSeller(
            riderLat: seller.lat!,
            riderLong: seller.long!,
            userLat: requestModel.senderLat!,
            userLong: requestModel.senderLong!);
        String distanceInKM = (distance / 1000)
            .toString()
            .substring(0, distance.toString().length ~/ 3);
        if (double.parse(distanceInKM.split(' ')[0]) <= 5) {
          i++;
          RequestModel request = RequestModel(
              documentId: '',
              serviceId: utils.getRandomid(),
              senderUid: utils.currentUserUid,
              serviceRequired: requestModel.serviceRequired,
              senderName: requestModel.senderName,
              senderPhone: requestModel.senderPhone,
              senderLat: requestModel.senderLat,
              senderLong: requestModel.senderLong,
              timeRequired: '0',
              status: 'pending',
              mechanicName: seller.name,
              description: requestModel.description,
              mechanicProfile: seller.profileImage,
              receiverUid: seller.uid, //this uid will change on every looop.
              senderAddress: requestModel.senderAddress,
              vehicle: requestModel.vehicle,
              senderDeviceToken: requestModel.senderDeviceToken,
              sentDate: utils.getCurrentDate(),
              sentTime: utils.getCurrentTime(),
              distance: distanceInKM.toString(),
              senderProfileImage: requestModel.senderProfileImage);

          final DocumentReference requestRef = await _sellerCollection
              .doc(seller.uid)
              .collection('Request')
              .add(request.toMap(request));

          final String documentId = requestRef.id;

          await requestRef.update({'documentId': documentId});
          await FirebaseUserRepository.notifySelleronComingRequest(
            seller.deviceToken!,
            requestModel.senderName!,
          );
        }
      }

      int count = total - i;
      utils.toastMessage("$count mechanic are out of range.");
      // utils.toastMessage("Request Sent");
    } catch (error) {
      // Handle the error appropriately
      utils.flushBarErrorMessage('Error sending request: $error', context);
      throw FirebaseException(
        plugin: 'FirebaseUserRepository',
        message: 'Failed to send request to sellers.',
      );
    }
  }

  Future<Position?> getUserCurrentLocation(context) async {
    try {
      await Geolocator.requestPermission();
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Location Permission Required"),
              content: const Text(
                "Please enable location permission from the app settings to access your current location.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  static Future<void> updateUserDeviceToken(String token, String doc) async {
    NotificationServices noti = NotificationServices();
    String to = await noti.getDeviceToken();
    if (to != token) {
      await FirebaseFirestore.instance
          .collection(doc)
          .doc(utils.currentUserUid)
          .update({
        'deviceToken': to,
      });
    }
  }

  Future<void> loadDataOnAppInit(context) async {
    try {
      final value = await getUserCurrentLocation(context);
      String address =
          await utils.getAddressFromLatLng(value!.latitude, value.longitude);

      UserModel? seller =
          Provider.of<UserProvider>(context, listen: false).user;
      String? refreshedToken = await _notificationServices.isTokenRefresh();
      await addlatLongToFirebaseDocument(
        value.latitude,
        value.longitude,
        address,
        refreshedToken,
        'users',
      );

      await Provider.of<UserProvider>(context, listen: false)
          .getUserFromServer(context);

      await Provider.of<AllSellerDataProvider>(context, listen: false)
          .getSellersDataFromServer(context);

      await FirebaseUserRepository.updateUserDeviceToken(
          seller!.deviceToken!, 'users');
      // Navigate to the home screen after loading the data
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      // Handle error if any
    }
  }

  loadSellerDataOnAppInit(context) async {
    try {
      final value = await getUserCurrentLocation(context);
      String address =
          await utils.getAddressFromLatLng(value!.latitude, value.longitude);
      String? refreshedToken = await _notificationServices.isTokenRefresh();

      await addlatLongToFirebaseDocument(
        value.latitude,
        value.longitude,
        address,
        refreshedToken,
        'sellers',
      );

      await Provider.of<SellerProvider>(context, listen: false)
          .getSellerFromServer(context);

      await Provider.of<AllSellerDataProvider>(context, listen: false)
          .getSellersDataFromServer(context);
      SellerModel? user =
          Provider.of<SellerProvider>(context, listen: false).seller;
      await FirebaseUserRepository.updateUserDeviceToken(
          user!.deviceToken!, 'sellers');

      // Navigate to the home screen after loading the data
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      // Handle error if any
    }
  }

  static Future<void> sendRequestForSpecificService(
    String sellerId,
    RequestModel requestModel,
    context,
  ) async {
    try {
      final DocumentReference requestRef = await _sellerCollection
          .doc(sellerId)
          .collection('Request')
          .add(requestModel.toMap(requestModel));

      final String documentId = requestRef.id;

      await requestRef.update({'documentId': documentId});
    } catch (error) {
      // Handle the error appropriately
      utils.flushBarErrorMessage('Error sending request: $error', context);
      throw FirebaseException(
        plugin: 'FirebaseUserRepository',
        message: 'Failed to send request to sellers.',
      );
    }
  }

  static Stream<List<RequestModel>> getRequests(context) async* {
    try {
      final CollectionReference requestCollection = FirebaseFirestore.instance
          .collection("sellers")
          .doc(utils.currentUserUid)
          .collection('Request');

      yield* requestCollection.snapshots().map((snapshot) {
        final List<RequestModel> models = snapshot.docs
            .map((docsSnap) => RequestModel.fromMap(docsSnap.data() as dynamic))
            .toList();
        return models;
      });
    } catch (e) {
      // Handle any potential errors here
      utils.flushBarErrorMessage('Error fetching requests: $e', context);
      yield []; // Yield an empty list in case of an error
    }
  }

  static Stream<List<RequestModel>> getAcceptedRequests(context) async* {
    try {
      final CollectionReference requestCollection = FirebaseFirestore.instance
          .collection("sellers")
          .doc(utils.currentUserUid)
          .collection('AcceptedRequest');

      yield* requestCollection.snapshots().map((snapshot) {
        final List<RequestModel> models = snapshot.docs
            .map((docsSnap) => RequestModel.fromMap(docsSnap.data() as dynamic))
            .toList();
        return models;
      });
    } catch (e) {
      // Handle any potential errors here
      utils.flushBarErrorMessage('Error fetching requests: $e', context);
      // print('Error fetching requests: $e');
      yield []; // Yield an empty list in case of an error
    }
  }

  static Stream<List<RequestModel>> getAcceptedRequestsForSenderId(
      String senderId, context) async* {
    try {
      final QuerySnapshot sellersSnapshot =
          await FirebaseFirestore.instance.collection("sellers").get();

      final List<RequestModel> acceptedRequests = [];

      for (QueryDocumentSnapshot sellerDoc in sellersSnapshot.docs) {
        final CollectionReference requestCollection =
            sellerDoc.reference.collection('AcceptedRequest');

        final QuerySnapshot requestSnapshot = await requestCollection
            .where('senderUid', isEqualTo: senderId)
            .get();

        final List<RequestModel> models = requestSnapshot.docs
            .map((docsSnap) => RequestModel.fromMap(docsSnap.data() as dynamic))
            .toList();

        acceptedRequests.addAll(models);
      }

      yield acceptedRequests;
    } catch (e) {
      // Handle any potential errors here
      utils.flushBarErrorMessage('Error fetching requests: $e', context);
      yield []; // Yield an empty list in case of an error
    }
  }

  static Stream<List<TransactionModel>> getTransactionByReceiverId(
      context) async* {
    try {
      final QuerySnapshot transactionsSnapshot = await FirebaseFirestore
          .instance
          .collection("transactions")
          .where('userId',
              isEqualTo: utils.currentUserUid) // Filter by receiverId
          .get();

      final List<TransactionModel> transactions = [];

      for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
        final TransactionModel transaction =
            TransactionModel.fromMap(transactionDoc.data() as dynamic);
        transactions.add(transaction);
      }

      yield transactions;
    } catch (e) {
      // Handle any potential errors here
      utils.flushBarErrorMessage('Error fetching transactions: $e', context);
      yield []; // Yield an empty list in case of an error
    }
  }

  static Future<void> deleteRequestFromEverySeller(
      String serviceId, context) async {
    try {
      // Retrieve all documents in the sellers collection
      QuerySnapshot querySnapshot = await _sellerCollection.get();

      // Iterate over the documents
      for (DocumentSnapshot sellerDocument in querySnapshot.docs) {
        // Get a reference to the "Request" subcollection of the current seller document
        CollectionReference requestCollection =
            sellerDocument.reference.collection('Request');

        // Query for documents that contain the specified document ID
        QuerySnapshot requestQuerySnapshot = await requestCollection
            .where('serviceId', isEqualTo: serviceId)
            .get();

        // Delete each document in the "Request" subcollection
        for (DocumentSnapshot requestDocument in requestQuerySnapshot.docs) {
          await requestDocument.reference.delete();
        }
      }
    } catch (e) {
      // print('Error deleting documents: $e');
      utils.flushBarErrorMessage('Error deleting documents: $e', context);
    }
  }

  static Future<void> deleteRequestDocument(
      String subCollection, String requestId, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(utils.currentUserUid)
          .collection(subCollection)
          .doc(requestId)
          .delete();
      utils.toastMessage("Request deleted");
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
    }
  }

  static Future<List<Map<String, dynamic>>> getSellersBasedOnService(
      String service) async {
    List<Map<String, dynamic>> sellersList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("sellers")
          .where("service", isEqualTo: service)
          .get();

      querySnapshot.docs.forEach((doc) {
        sellersList.add(doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      // Handle any errors that may occur
      utils.toastMessage(e.toString());
    }

    return sellersList;
  }

  static notifySelleronComingRequest(
      String sellerDeviceToken, String userName) async {
    // send notification from one device to another
    var data = {
      'to': sellerDeviceToken,
      'notification': {
        'title': 'New Request',
        'body': '${userName} want your service',
        // "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': 'msj', 'id': 'Asif Taj'}
    };

    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAxDHbazE:APA91bEK6_7-USKl15JqE4bH_ZZUrMHGCZTr1QCAT-WYJGPo3eTcAaLco3769dxP-GINLskhZOwz2KmddEL8VCGPERQBFUgysXEKTt2TNd49z2qqw6zd98oncZcTbrPpbgLe20Opw0Nb'
            })
        .then((value) {})
        .onError((error, stackTrace) {
          print(error);
          //  utils.flushBarErrorMessage(error.toString(), context);
        });
  }

  static notifyUseronInvoice(String userDeviceToken, String sellerName) async {
    // send notification from one device to another
    var data = {
      'to': userDeviceToken,
      'notification': {
        'title': 'New Invoice',
        'body': '${sellerName} sent you invoice',
        // "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': 'msj', 'id': 'Asif Taj'}
    };

    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAxDHbazE:APA91bEK6_7-USKl15JqE4bH_ZZUrMHGCZTr1QCAT-WYJGPo3eTcAaLco3769dxP-GINLskhZOwz2KmddEL8VCGPERQBFUgysXEKTt2TNd49z2qqw6zd98oncZcTbrPpbgLe20Opw0Nb'
            })
        .then((value) {})
        .onError((error, stackTrace) {
          print(error);
          //  utils.flushBarErrorMessage(error.toString(), context);
        });
  }

  static notifyUserOnRequestAccepted(
      String userDeviceToken, String sellerName) async {
    // send notification from one device to another
    var data = {
      'to': userDeviceToken,
      'notification': {
        'title': 'Request Accepted',
        'body': 'Your request is accepted by ${sellerName} ',
        // "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': 'msj', 'id': 'Asif Taj'}
    };

    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAxDHbazE:APA91bEK6_7-USKl15JqE4bH_ZZUrMHGCZTr1QCAT-WYJGPo3eTcAaLco3769dxP-GINLskhZOwz2KmddEL8VCGPERQBFUgysXEKTt2TNd49z2qqw6zd98oncZcTbrPpbgLe20Opw0Nb'
            })
        .then((value) {})
        .onError((error, stackTrace) {
          print(error);
          //  utils.flushBarErrorMessage(error.toString(), context);
        });
  }

// Update rider's location in Firestore
  static Future<void> updateRiderLocation(
      double latitude, double longitude, String rider_id) async {
    FirebaseFirestore.instance.collection('sellers').doc(rider_id).update({
      'lat': latitude,
      'long': longitude,
      // Add any additional rider information you need to update
    });
  }
}
