import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/widgets/product_card.dart';
import 'package:intl/intl.dart';

class ProductList extends StatelessWidget {
  final bool proScreen;
  ProductList(this.proScreen);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _formate=NumberFormat("##,##,##0");

    return Container(
    width: MediaQuery.of(context).size.width,
    color: Colors.white,

  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder<QuerySnapshot>(
      future: _service.products.orderBy('postedAt').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(left: 140,right: 140),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              backgroundColor: Colors.grey.shade100,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Fresh Recommendations',
                style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            GridView.builder(
              shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2/3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data.size,
                itemBuilder: (BuildContext context, int i){
                  var data=snapshot.data.docs[i];
                  var rent=int.parse(data['rent']);
                  String _formattedRent = '${_formate.format(rent)}';

                  return ProductCard(data: data, formattedRent: _formattedRent);
                }),
          ],
        );
      },
    ),
  ),
    );
  }
}

