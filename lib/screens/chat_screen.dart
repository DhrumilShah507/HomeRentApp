import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/screens/chat_card.dart';


import 'firestore_service.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();


    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('Chats',style: TextStyle(color: Theme.of(context).primaryColor),),
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            labelColor: Theme.of(context).primaryColor,
            indicatorWeight: 6,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'ALL',),
              Tab(text: 'GET ON RENT',),
              Tab(text: 'GIVING ON RENT',),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),

          ],
        ),
      ),
    );
  }
}

/*Container(
              child : StreamBuilder<QuerySnapshot>(
              stream: _service.messages.where('users',arrayContains: _service.users.id).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                  }

                  return ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return  ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),*/