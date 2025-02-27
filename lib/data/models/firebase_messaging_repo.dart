import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'chat_user.dart';
import 'package:e_mech/utils/utils.dart';

import 'message.dart';

class FirebaseMessagingRepo {
  static final firestore = FirebaseFirestore.instance;
 // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // ---------------------  chatting app methods ------------------------------------

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(utils.currentUserUid)
        .collection('my_users')
        .snapshots();
  }
//   // for getting all users from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
//       List<String> userIds) {
//     log('\nUserIds: $userIds');
// print(userIds);
// print(userIds.isEmpty);

//     return firestore
//         .collection('sellers')
//         .where('id',
//             whereIn: userIds.isEmpty
//                 ? ['']
//                 : userIds) //because empty list throws an error
//         .where('id', isNotEqualTo: utils.currentUserUid)
//         .snapshots();
//   }
static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
  return firestore
      .collection('sellers')
      .where(FieldPath.documentId, whereIn: userIds)
      .snapshots();
}

static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSellers(List<String> userIds) {
  return firestore
      .collection('sellers')
      .where(FieldPath.documentId, whereIn: userIds)
      .snapshots();
}

  // useful for getting conversation id
  static String getConversationID(String id) =>
      utils.currentUserUid.hashCode <= id.hashCode
          ? '${utils.currentUserUid}_$id'
          : '${id}_${utils.currentUserUid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String secondPersonId,) {
    return firestore
        .collection('chats/${getConversationID(secondPersonId)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
     String secondPersonUid,String secondPersonDeviceToken, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId:secondPersonUid,
        msg: msg,
        read: '',
        type: type,
        fromId: utils.currentUserUid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(secondPersonUid)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(secondPersonDeviceToken, type == Type.text ? msg : 'image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String secondPersonUid) {
    return firestore
        .collection('chats/${getConversationID(secondPersonUid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      String secondPersonDeviceToken, String msg) async {
    try {
      final body = {
        "to":secondPersonDeviceToken,
        "notification": {
          "title": "naveed", //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    // if (message.type == Type.image) {
    //   await storage.refFromURL(message.msg).delete();
    // }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  //send chat image
  static Future<void> sendChatImage(String secondPersonUid,String secondPersonDeviceToken, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(secondPersonUid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(secondPersonUid,secondPersonDeviceToken, imageUrl, Type.image);
  }


// for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
     String secondPersonUid,String secondPersonDeviceToken, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(secondPersonUid)
        .collection('my_users')
        .doc(utils.currentUserUid)
        .set({}).then((value) => sendMessage(secondPersonUid,secondPersonDeviceToken, msg, type));
  }

  // // for updating user information
  // static Future<void> updateUserInfo() async {
  //   await firestore.collection('users').doc(user.uid).update({
  //     'name': me.name,
  //     'about': me.about,
  //   });
  
  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      String secondPersonUid) {
    return firestore
        .collection('users')
        .where('uid', isEqualTo: secondPersonUid)
        .snapshots();
  }
static Stream<QuerySnapshot<Map<String, dynamic>>> getSellerInfo(
      String secondPersonUid) {
    return firestore
        .collection('sellers')
        .where('uid', isEqualTo: secondPersonUid)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(utils.currentUserUid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'push_token': me.pushToken,
    });
  }
  }

