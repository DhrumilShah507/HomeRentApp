import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/screens/chat_stream.dart';
import 'package:home_rent_app/screens/chat_stream.dart';
import 'package:home_rent_app/screens/firestore_service.dart';

class ChatConversations extends StatefulWidget {
  final String chatRoomId = 'xyz';
  //ChatConversations({required this.chatRoomId});

  @override
  _ChatConversationsState createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  FirebaseService _service = FirebaseService();
  var chatMessageController = TextEditingController();
  // Stream chatMessageStream;
  bool _send = false;

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': chatMessageController.text,
        'sentBy': _service.users.id,
        'time': DateTime.now().microsecondsSinceEpoch
      };

      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp)),
        //  _service.popUpMenu(widget.chatRoomId,context),

        ],
        shape: Border(bottom: BorderSide(color: Colors.grey)),
      ), //will  design later
      body: Container(
        child: Stack(
          children: [
            ChatStream(widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade800)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatMessageController,
                          style:
                          TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                              hintText: 'Type Message',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              border: InputBorder.none),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _send = true;
                              });
                            } else {
                              setState(() {
                                _send = false;
                              });
                            }
                          },
                          onSubmitted: (value) {
                            if (value.length > 0) {
                              sendMessage();
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
