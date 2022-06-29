import 'package:flutter/material.dart';
import 'package:home_rent_app/categories/subCat_screen.dart';
import 'package:home_rent_app/forms/seller_form.dart';
import 'package:home_rent_app/provider/cat_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/screens/firestore_service.dart';

import 'package:provider/provider.dart';


class CategoryListScreen extends StatelessWidget {
  static const String id ='category-list-screen';
  const CategoryListScreen({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    FirebaseService _service=FirebaseService();

    var _catProvider =Provider.of<CategoryProvider>(context);

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
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }

            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    var doc = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          //sub categories
                          _catProvider.getCategory(doc['catName']);
                          _catProvider.getCatSnapshot(doc);
                            Navigator.pushNamed(context, SellerCarForm.id);

                          //Navigator.pushNamed(context, SellerCarForm.id);
                        },
                        leading: Image.network(doc['image'],width: 40,),
                        title: Text(doc['catName'],style: TextStyle(fontSize: 15),),
                        trailing: Icon(Icons.arrow_forward_ios,size: 12,),
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
