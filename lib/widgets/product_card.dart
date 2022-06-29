import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/provider/product_provider.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/screens/product_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';



class ProductCard extends StatefulWidget {

  const ProductCard({
    Key key,
    @required this.data,
    @required String formattedRent,
  }) : _formattedRent = formattedRent, super(key: key);

  final QueryDocumentSnapshot<Object> data;
  final String _formattedRent;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _formate=NumberFormat("##,##,##0");
  FirebaseService _service = FirebaseService();

  String address = '';
  DocumentSnapshot sellerDetails;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _service.getUserData().then((value){
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

    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      onTap: (){
        _provider.getProductDetails(widget.data);
        _provider.getSellerDetails(sellerDetails);
        Navigator.pushReplacementNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              child: Center(child: Image.network(widget.data['images'][0]),),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Text(widget.data['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.data['category'],style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.data['type'],maxLines: 1,overflow: TextOverflow.ellipsis,),
                          Text('Rent '+widget._formattedRent,style: TextStyle(fontWeight: FontWeight.bold),),

                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_pin,size:14,color: Colors.black38,),
                      Flexible(child: Text(address,maxLines: 1,overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                ],
              ),
              Positioned(
                  right: 0.0,
                child: LikeButton(
                  circleColor:
                  CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.redAccent : Colors.grey,
                    );
                  },


                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
