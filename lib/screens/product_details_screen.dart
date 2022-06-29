import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:home_rent_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/provider/cat_provider.dart';
import 'package:home_rent_app/provider/product_provider.dart';
import 'package:home_rent_app/screens/chat_conversation_screen.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';


class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';


  const ProductDetailsScreen({Key key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  FirebaseService _service = FirebaseService();
  bool _loading=true ;
  int _index =0;
  @override
  void initState() {
    Timer(Duration(seconds: 2),(){
      setState(() {
        _loading=false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  createChatRoom(ProductProvider _provider){
    Map<String,dynamic> product = {
      'productId': _provider.productData.id,
      'productImages': _provider.productData['images'][0],
      'rent':_provider.productData['rent'],
      'maintenace':_provider.productData['maintenace'],
      'title':_provider.productData['title'],

    };
    List<String>users = [
      _provider.sellerDetails['uid'],
      _service.users.id
    ];
    String chatRoomId = '${_provider.sellerDetails['uid']}.${_service.users.id}.${_provider.productData.id}';
    Map<String,dynamic>chatData={
      'users': users,
      'chatRoomId': chatRoomId,
      'product': product,
      'read':false,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };
    _service.createChatRoom(
      chatData: chatData
    );
    Navigator.push (
      context,
      MaterialPageRoute (
        builder: (BuildContext context) =>  ChatConversations(),
      ),
    );
  }
 /* _callSeller(number){
    launch(number);
  }*/


  @override
  Widget build(BuildContext context) {
    final _formate=NumberFormat("##,##,##0");

    var _provider= Provider.of<CategoryProvider>(context);
    var _productProvider = Provider.of<ProductProvider>(context);

    var data = _productProvider.productData;
    var _rent = int.parse(data['rent']);
    var _maintenace = int.parse(data['maintenace']);
   var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
   var _date= DateFormat.yMMMd().format(date);
    String rent = _formate.format(_rent);
    String maintenace = _formate.format(_maintenace);
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, MainScreen.id);
              },
              icon: Icon(
                Icons.share_outlined,
                  color: Colors.black
              ),
          ),
          LikeButton(
            circleColor:
            CircleColor(start: Color(0xffe7124e), end: Color(0xfff5112c)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xffe5339e),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.redAccent : Colors.grey,
              );
            },


          )

        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child:Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color: Colors.grey.shade300,
                    child: _loading ? Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                        SizedBox(height: 10,),
                        Text('Loading your Ad'),
                      ],
                    ),):
                    Stack(
                      children: [
                        Center(
                          child: PhotoView(
                            backgroundDecoration: BoxDecoration(
                              color: Colors.grey.shade300
                            ),
                            imageProvider: NetworkImage(data['images'][_index]),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data['images'].length,
                              itemBuilder: (BuildContext context, int i){
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      _index=i;
                                    });
                                  },
                                  child: Container(
                                    /*decoration: BoxDecoration(
                                      border: Border.all(color: Colors.teal),),*/
                                    height: 60,
                                    width: 60,
                                    color: Colors.white,
                                    child: Image.network(data['images'][i]),

                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )
                    ,
                  ),
                  _loading ? Container()
                      :Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title'].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                        Row(
                          children: [
                            Icon(Icons.home_filled,size:20,color: Colors.black38,),
                            SizedBox(width: 5,),
                            Text(
                                data['category'].toUpperCase(),
                                textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 14),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,size:20,),
                            Flexible(
                              child: Text(
                                _productProvider.sellerDetails==null
                                    ?" "
                                    :_productProvider.sellerDetails['address'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    //    Text('RENT \& MAINTENANCE', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('RENT', style: TextStyle(fontWeight: FontWeight.bold,),),
                                Row(
                                  children: [
                                    Icon(Icons.monetization_on,size:20,),
                                    SizedBox(width: 5,),
                                    Text(rent, style: TextStyle(fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                Text('MAINTENANCE', style: TextStyle(fontWeight: FontWeight.bold,),),
                                Row(
                                  children: [
                                    Icon(Icons.construction,size:20,),
                                    SizedBox(width: 5,),
                                    Text(maintenace, style: TextStyle(fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          color: Colors.grey.shade300,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 10 ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.king_bed,size:20,),
                                        SizedBox(width: 10,),
                                        Text(data['type'].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold,),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.bathtub,size: 20,),
                                        SizedBox(width: 10,),
                                        Text(data['noOfBathroom'], style: TextStyle(fontWeight: FontWeight.bold,),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.chair,size:20,),
                                        SizedBox(width: 10,),
                                        Text(data['furniture'].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text('Description', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey.shade300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data['description'].toLowerCase(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),

                      /*  Row(
                          children: [
                            Text('POSTED DATE',style: TextStyle(fontSize: 12),),
                            Text(_date,style: TextStyle(fontSize: 12)),
                          ],
                        ),*/
                        Divider(color: Colors.grey,),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 38,
                              child: Icon(
                                CupertinoIcons.person_alt,
                                color: Colors.redAccent,
                                size: 60,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  _productProvider.sellerDetails==null?" ":
                                _productProvider.sellerDetails['name'].toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                subtitle: Text("SEE PROFILE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,size: 12,),
                                  onPressed: (){

                                  }
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: Colors.grey,),
                        Text('Posted at : $_date'),
                        /*Text('Ad Posted at',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                          height: 80,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Text("Seller Location"),
                          ),
                        ),*/
                        SizedBox(height: 20,),
                        Text("AD ID : ${data['postedAt']}",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                       // SizedBox(height: 20,),
                        SizedBox(height: 60,),
                      ],
                    ),
                  ),
                 /* Expanded(
                    child: Container(
                      child:TextButton.icon(onPressed: (){},
                        icon: Icon(Icons.location_on_outlined,size: 12,color: Colors.black38,),
                        label: Text(
                          _productProvider.sellerDetails==null
                              ?" "
                              :_productProvider.sellerDetails['address'],
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),*/

                ],
              ),
            )
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: NeumorphicButton(
                onPressed: (){
                  createChatRoom(_productProvider);

                },
                style: NeumorphicStyle(color: Colors.teal),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.chat_bubble,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Chat',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              )),
              SizedBox(width: 20,),
              Expanded(child: NeumorphicButton(
                onPressed: (){

                },
                style: NeumorphicStyle(color: Colors.teal),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.phone,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Call',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
