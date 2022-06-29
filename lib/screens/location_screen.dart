// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/screens/home_screen.dart';
import 'package:home_rent_app/screens/main_screen.dart';


//import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LocationScreen extends StatefulWidget{
  static const String id ='location-screen';

  final Widget popScreen;
  LocationScreen({this.popScreen});


  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>{

  bool _loading=true;
  FirebaseService _service=FirebaseService();

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address;
  String manual_address;
//  get geoCode => null;




 getLocation() async {

   Location location = new Location();
   bool _serviceEnabled;
   PermissionStatus _permissionGranted;
   LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

      _locationData = await location.getLocation();
  final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}");


 setState(() {
     address=first.addressLine;
     countryValue=first.countryName;
   });

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);

  /*  ProgressDialog progressDialog =ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching Location...',
      progressIndicatorColor: Colors.blueAccent,
    );*/

    FirebaseFirestore.instance//_service.users
        .collection('users')
        .doc('user')//_service.user.uid
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        if(document['address']!=null){
          print("********************** Got Address **********************");
          setState(() {
            _loading=true;
          });
        //  Navigator.pushReplacementNamed(context, MainScreen.id);
        }else{
          print("********************** Not Getting Address **********************");
          _loading=false;
        }
      }
    });

    void _showModalBottomSheet(BuildContext context) {

      getLocation().then((location){
        if(location!=null){
          _dialog.hide();
          showModalBottomSheet<void>(
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (BuildContext context) => Container(
                child:  Column(
                  children: [
                    SizedBox(height: 26,),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                          color: Colors.black
                      ),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear),),
                          SizedBox(width: 10,),
                          Text('Location',style: TextStyle(color: Colors.black),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Search city area or neighbourhood',
                                hintStyle:TextStyle(color: Colors.grey),
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        //save address to firestore
                        getLocation().then((value){
                          if(value!=null){
                            _service.updateUser({
                              'location': GeoPoint(value.latitude,value.longitude),
                              'address':address,
                            }, context).whenComplete((){
                              Navigator.pushReplacementNamed(context, MainScreen.id);
                            });
                          }

                        });

                      },
                      leading: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Use current location',
                        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        location == null ?'Fetching location' : address.toString(),
                        style: TextStyle(fontSize: 12),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,bottom: 6,top: 6),
                        child: Text(
                          'CHOOSE CITY',
                          style: TextStyle(
                              color: Colors.blueGrey.shade900,fontSize: 12
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: CSCPicker(
                          layout: Layout.vertical,
                          dropdownDecoration: BoxDecoration(shape: BoxShape.rectangle),
                          defaultCountry: DefaultCountry.India,
                          flagState: CountryFlag.DISABLE,
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged:(value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged:(value) {
                            setState(() {
                            /*   if(stateValue==""){
                                return SizedBox(
                                  child: ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Hello!'),
                                    ),
                                ));
                              }*/
                              cityValue = value;
                              manual_address="$cityValue $stateValue $countryValue";
                              _service.updateUser({         
                                'address':manual_address,
                                'city':cityValue,
                                'state':stateValue,
                                'country':countryValue
                              }, context);

                            });
                            print(address);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),);
        }else{
          _dialog.hide();
        }
      });
    }




    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,
      body: Column(

        children: [
          Image.asset('images/location.jpg'),
          SizedBox(
            height: 20,
          ),
          Text(
            'Where do you want \nto get house',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'To enjoy all that we have to offer you\n we need to know where to look for them',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left:20,right: 10,bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (){
                      getLocation().then((value){
                        if(value!=null){
                          _service.updateUser({
                            'location': GeoPoint(value.latitude,value.longitude),
                            'address':address,
                          }, context).whenComplete((){
                            Navigator.pushReplacementNamed (
                              context, MainScreen.id);
                          });
                          //print('====================================Location Data='+value.toString()+'====================================')
                        }
                      });
                    },
                    icon: Icon(CupertinoIcons.location),
                    label:
                    Text(
                      'Around me',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue
                        ))
                    ),
                ),

              ],
            ),
          ),
          Center(

            child: InkWell(
              onTap: (){
                _dialog.show(message: 'Loading...', type: SimpleFontelicoProgressDialogType.normal);
                _showModalBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2))
                  ),
                  child: Text(
                    'Set location Manualy',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(_loading)
          Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),),
          ),
        ],
      ),
    );
  }
}

