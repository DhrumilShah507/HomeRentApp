
import 'package:geocoder/model.dart';


import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/screens/popup_menu_model.dart';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';



class FirebaseService{
 // User user = FirebaseAuth.instance.curruntUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('Categories');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  //User? user = FirebaseAuth.instance.currentUser;
  Future<void> updateUser(Map<String,dynamic>data,context)  {


    return users
        .doc('user')
        .update(data)
        .then((value) {
          return Navigator.pushNamed(context,'');
        },)
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A SnackBar has been shown.'),
              ),
          );
    });

  }
 // Future<String>getAddress(lat,long)async{
getAddress(lat,long) async {
    //string is used to return to return address
    final coordinates = new Coordinates(lat,long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    //return first.addressLine;
  }

  Future<DocumentSnapshot>getUserData()async{
    DocumentSnapshot doc = await users.doc('user').get();//user.uid
    return doc;
  }

  Future<DocumentSnapshot>getProductDetails()async{
    DocumentSnapshot doc = await products.doc('id').get();//user.uid
    return doc;
  }

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  createChat(String chatRoomId,message){

    messages.doc(chatRoomId).collection('chats').add(message).catchError((e){
      print(e.toString());
    });

    messages.doc(chatRoomId).update({
      'lastChat':message['message'],
      'lastChatTime':message['time'],
      'read' : false
    });

  }

  getChat(chatRoomId)async{
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }

  deleteChat(chatRoomId)async{
    return messages.doc(chatRoomId).delete();
  }


  popUpMenu(chatData,context){
    CustomPopupMenuController _controller = CustomPopupMenuController();
    List<PopupMenuModel> menuItems = [
      PopupMenuModel('Delete Chat', Icons.delete),
      PopupMenuModel('Mark as Given', Icons.done),
    ];

    return CustomPopupMenu(
      child: Container(
        child: Icon(Icons.more_vert_sharp, color: Colors.black),
        padding: EdgeInsets.all(20),
      ),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    if(item.title == 'Delete Chat'){
                      deleteChat(chatData['chatRoomId']);
                      _controller.hideMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content : Text('Chat Deleted'),

                        ),
                      );

                    }
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 15,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding:
                            EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
     // pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
    );
  }
}