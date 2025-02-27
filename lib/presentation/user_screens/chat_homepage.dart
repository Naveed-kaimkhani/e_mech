import 'dart:developer';
import 'package:e_mech/data/models/firebase_messaging_repo.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/no_data_found_screen.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/chat_user_card.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/seller_model.dart';
import '../../main.dart';

//home screen -- where all available contacts are shown
class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  // for storing all users
  List<SellerModel> _list = [];

  // for storing searched items
  final List<SellerModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // FirebaseMessagingRepo.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (message.toString().contains('resume')) {
        FirebaseMessagingRepo.updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) {
        FirebaseMessagingRepo.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: appBar(),

          //body
          body: StreamBuilder(
            stream: FirebaseMessagingRepo.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return snapshot.data!.docs.isNotEmpty
                      ? StreamBuilder(
                          stream: FirebaseMessagingRepo.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),

                          //get only those user, who's ids are provided
                          builder: (context, snapshot) {
                            print("users");
                            print(snapshot.data);
                            switch (snapshot.connectionState) {
                              //if data is loading
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                              // return const Center(
                              //     child: CircularProgressIndicator());

                              //if some or all data is loaded then show it
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _list = data
                                        ?.map((e) =>
                                            SellerModel.fromMap(e.data()))
                                        .toList() ??
                                    [];

                                if (_list.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      padding:
                                          EdgeInsets.only(top: mq.height * .01),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(
                                            user: _isSearching
                                                ? _searchList[index]
                                                : _list[index]);
                                      });
                                } else {
                                  return Center(
                                    child: NoDataFoundScreen(
                                        text: "No Messages Found"),
                                  );
                                }
                            }
                          },
                        )
                      : Center(child: NoDataFoundScreen(text: "No User Found"));
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      // leading: const Icon(CupertinoIcons.home),
      backgroundColor: Styling.primaryColor,
      title: _isSearching
          ? TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name, Email, ...'),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              //when search text changes then updated search list
              onChanged: (val) {
                //search logic
                _searchList.clear();

                for (var i in _list) {
                  if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                      i.email!.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(i);
                    setState(() {
                      _searchList;
                    });
                  }
                }
              },
            )
          : const Text('Chats'),
      actions: [
        //search user button
        IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching
                ? CupertinoIcons.clear_circled_solid
                : Icons.search)),

        //more features button
        // IconButton(
        //     onPressed: () {
        //       // Navigator.push(
        //       //     context,
        //       //     MaterialPageRoute(
        //       //         builder: (_) => ProfileScreen(user: FirebaseMessagingRepo.me)));
        //     },
        //     icon: const Icon(Icons.more_vert))
      ],
    );
  }

  // for adding new chat user
  void _addUserModelDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      // if (email.isNotEmpty) {
                      //   await FirebaseMessagingRepo.addUserModel(email).then((value) {
                      //     if (!value) {
                      //       // Dialogs.showSnackbar(
                      //       //     context, 'User does not Exists!');
                      //         utils.flushBarErrorMessage( 'User does not Exists!', context);
                      //     }
                      //   });
                      // }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
