// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:home_rent_app/provider/product_provider.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/screens/location_screen.dart';
import 'package:home_rent_app/services/search_services.dart';


class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key key}) : super(key: key);

  //static List<Products> people = [];



  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseService _service=FirebaseService();
  SearchServices _search= SearchServices();



  static List<Products> products = [];

  String address = '';
  DocumentSnapshot sellerDetails;
  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          products.add(
            Products(
              document: doc,
              title: doc['title'],
              type: doc['type'],
              furniture: doc['furniture'],
              category:doc['category'],
              description: doc['description'],
              postedAt: doc['postedAt'],
              rent: doc['rent'],
              maintenace: doc['maintenace']
            )
          );
          getSellerAddress();//doc['sellerUid']
        });
      });
    });
    super.initState();
  }
  getSellerAddress(){
    _service.getUserData().then((value) {
     // print(value.data());
      if(mounted){
        setState(() {
          address=value['address'];
          sellerDetails=value;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
   // var _provider = Provider.of(context)<ProductProvider>(context);



    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc('user').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          if(data['address']==null){
            //then will check nex data
            if(data['state']==null){
              GeoPoint latLong=data['location'];
              _service.getAddress(latLong.latitude,latLong.longitude).then((adrs){
                //this address will show in app bar
                return appBar(adrs, context,sellerDetails);//_provider,
              });
            }

          }else{
            return appBar(data['address'], context,sellerDetails);//_provider,
          }
         // return appBar('Updated Location', context);
        }

        return Text("Fetching Location...");
      },
    );
  }

  Widget appBar(address,context,sellerAddress){//provider,
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
          onTap: (){
            Navigator.pushNamed(context,LocationScreen.id);
          },
          child: Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      color: Colors.black,
                      size: 18,
                    ),
                    Flexible(
                      child: Text(address,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                      ),
                    ),
                   Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black,size:18)
                  ],
                ),
              ),
            ),
          ),
        ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(16),
        child: InkWell(

          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: TextField(
                              onTap: (){
                                _search.search(
                                    context: context,
                                    productsList: products,
                                    address: address,
                                    //provider: provider,
                                  sellerDetails:sellerAddress
                                );
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search,),
                                  labelText: 'Find House For Rent',
                                  labelStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.only(left: 10,right: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        // Icon(Icons.notifications_none),
                        SizedBox(width: 5,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
