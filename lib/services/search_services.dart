
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/provider/product_provider.dart';
import 'package:home_rent_app/screens/product_details_screen.dart';
import 'package:home_rent_app/screens/product_list.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class Products {
  final String title,description,category,rent,type,furniture,maintenace;

  final num postedAt;
  DocumentSnapshot  document;
  Products(
      {this.title,
        this.description,
        this.category,
        this.rent,
        this.type,
        this.furniture,
        this.postedAt,
        this.document,
        this.maintenace
      });

}
class SearchServices{
  search({context,productsList,address,provider,sellerDetails}){
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
          onQueryUpdate: (s) => print(s),
        items: productsList,
        searchLabel: 'Search home',
        suggestion: SingleChildScrollView(child: ProductList(true)),
        failure: Center(
          child: Text('No home found :('),
        ),
        filter: (product) => [
          product.title,
          product.description,
          product.category,
          product.rent,
          product.type,
          product.furniture,
         // product.postedAt,
         // product.document,
          product.maintenace
        ],
        builder: (product) {

          final _formate=NumberFormat("##,##,##0");
          var rent=int.parse(product.rent);
          String _formattedRent = '${_formate.format(rent)}';

          var date = DateTime.fromMicrosecondsSinceEpoch(product.postedAt);
          var _date= DateFormat.yMMMd().format(date);
          var _provider = Provider.of<ProductProvider>(context);

          return InkWell(
            onTap: (){
              print(sellerDetails);
              provider.getProductDetails(product.document);
               provider.getSellerDetails(sellerDetails);
               Navigator.pushReplacementNamed(context, ProductDetailsScreen.id);
            },
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        child: Image.network(product.document['images'][0]),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formattedRent,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20),),
                              Text(product.title),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Posted at : $_date"),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on,size: 14,color: Colors.black38,),
                                  Flexible(child:
                                  Container(
                                      width: MediaQuery.of(context).size.width-148,
                                      child: Flexible(child: Text(address,overflow: TextOverflow.ellipsis ,)))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}