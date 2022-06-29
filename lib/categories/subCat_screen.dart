
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/screens/firestore_service.dart';


class SubCatList extends StatelessWidget {
  const SubCatList({Key key}) : super(key: key);
  static const String id = 'subCat-screen';

  @override
  Widget build(BuildContext context) {

    FirebaseService _service=FirebaseService();


    DocumentSnapshot args = ModalRoute.of(context).settings.arguments as DocumentSnapshot<Object>;

    var id;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args. id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            var data = snapshot.data['subCat'];
            return Container(
              child: ListView.builder(

                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index){
                  //  var doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: ListTile(
                        onTap: (){
                          //sub categories
                        //  Navigator.pushNamed(context, SubCatList.id,arguments: doc);
                        },
                       // leading: Image.network(doc['image'],width: 40,),
                        title: Text(data[index],style: TextStyle(fontSize: 15),),
                       // trailing: Icon(Icons.arrow_forward_ios,size: 12,),
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
