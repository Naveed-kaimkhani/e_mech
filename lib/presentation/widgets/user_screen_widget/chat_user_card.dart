import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_mech/data/models/firebase_messaging_repo.dart';
import 'package:e_mech/data/models/message.dart';
import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/user_screens/userside_chat_screen_.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../main.dart';
import '../../../utils/date_utils.dart';
import '../../seller_screens/SellerSideChatScreen.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final SellerModel user;

  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 2),
      color: Color.fromARGB(255, 255, 229, 229),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          //for navigating to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserSideChatScreen(user: widget.user),
            ),
          );
        },
        child: StreamBuilder(
          stream: FirebaseMessagingRepo.getLastMessage(widget.user.uid!),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return SizedBox(
              height: 60.h,
              width: 60.w,
              child: Center(
                child: ListTile(
                  //user profile picture
                  leading: SizedBox(
                    width: mq.height * .065,
                    height: mq.height * .065,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: ProfilePic(
                        url: widget.user.profileImage!,
                        height: mq.height * .065,
                        width: mq.height * .065,
                      ),
                    ),
                  ),

                  //user name
                  title: Text(
                    utils.capitalizeFirstLetter(widget.user.name!),
                    style: TextStyle(fontSize: 22.sp),
                  ),

                  //last message
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.service!,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.sp),
                  ),

                  //last message time
                  trailing: _message == null
                      ? null //show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != utils.currentUserUid
                          ?
                          //show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          :
                          //message sent time
                          Text(
                              MyDateUtils.getLastMessageTime(
                                context: context,
                                time: _message!.sent,
                              ),
                              style: const TextStyle(color: Colors.black54),
                            ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}