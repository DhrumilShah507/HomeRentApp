import 'package:flutter/material.dart';
import 'package:home_rent_app/screens/banner.dart';
import 'package:home_rent_app/screens/product_list.dart';
import 'package:home_rent_app/widgets/category_widgets.dart';
import 'package:home_rent_app/widgets/custom_appBar.dart';
import 'package:location/location.dart';


class HomeScreen extends StatelessWidget{
  static const String id = 'home-screen';
  //final LocationData locationData;
 // HomeScreen({this.locationData});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SafeArea(child: CustomAppBar())),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  children: [
                    BannerWidget(),
                    CategoryWidget(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            ProductList(true),
          ],
        ),
      ),
    );
    // );
  }
}