import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/widgets/product_card.dart';
import 'package:intl/intl.dart';


class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _formate=NumberFormat("##,##,##0");

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('My Ads',style: TextStyle(color: Colors.black),),
          bottom: TabBar(
            indicatorColor: Colors.teal,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight:6,
              tabs:[
               Tab(
                 child: Text('ADS',style: TextStyle(color: Colors.teal),),
               ),
                Tab(
                  child: Text('FAVOURITE',style: TextStyle(color: Colors.teal),),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products.get(),//_service.products.orderBy('postedAt').get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 140,right: 140),
                        child: Container(
                          height: 56,
                          child: Center(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                              backgroundColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('My Ads',
                            style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2/2.6,
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Center(child: Text('My Favorite'),)
          ],
        ),
      ),
    );
  }
}