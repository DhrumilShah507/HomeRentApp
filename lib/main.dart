
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/provider/cat_provider.dart';
import 'package:home_rent_app/provider/product_provider.dart';
import 'package:home_rent_app/screens/home_screen.dart';
import 'package:home_rent_app/screens/location_screen.dart';
import 'package:home_rent_app/screens/login.dart';
import 'package:home_rent_app/screens/product_details_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'categories/category_list.dart';
import 'categories/subCat_screen.dart';
import 'forms/seller_form.dart';
import 'forms/user_review_screen.dart';
import 'screens/main_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType=null;
  runApp(
    MultiProvider(
      providers:[
        Provider (create: (_)=> CategoryProvider(),),
        Provider (create: (_)=> ProductProvider(),)
      ],child: MyApp())
      //debugshowmodeBanner:false;
  );

}
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        LocationScreen.id:(context)=>LocationScreen(),
        MainScreen.id: (context) => MainScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCatList.id: (context) => SubCatList(),
        SellerCarForm.id: (context)=>SellerCarForm(),
        UserReviewScreen.id: (context)=>UserReviewScreen(),
        ProductDetailsScreen.id: (context)=>ProductDetailsScreen(),
      },
      home:AnimatedSplashScreen(
        splash: 'images/Home.jpeg',
        nextScreen: LogInScreen(),
        splashTransition: SplashTransition.rotationTransition,
        splashIconSize: 300,
      ),
    );
  }
}



/*class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

  }
}*/