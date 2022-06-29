
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/provider/cat_provider.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/screens/home_screen.dart';
import 'package:home_rent_app/screens/main_screen.dart';
import '';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


class UserReviewScreen extends StatefulWidget {
  //const UserReviewScreen({Key? key}) : super(key: key);
  static const String id = 'user-review-screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading =false;

  FirebaseService _service=FirebaseService();

  var _nameController = TextEditingController();

  var _countryController = TextEditingController();

  var _emailController = TextEditingController();

  var _phoneController = TextEditingController();

  var _addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();
    setState(() {
     /* _nameController.text=_provider.userDetails.['name'];
      _phoneController.text=_provider.userDetails.['phone'];
      _emailController.text=_provider.userDetails.['email'];
      _addressController.text=_provider.userDetails.['address'];*/
    //  _typeController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['type'];

    });
    super.didChangeDependencies();
  }

  Future<void> updateUser(provider,Map<String,dynamic>data,context)  {


    return _service.users
        .doc('user')//_service.user.uid
        .update(data)
        .then((value) {
          saveProductsToDb(provider,context);
      //return Navigator.pushNamed(context,'');
    },).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A SnackBar has been shown.'),
        ),
      );
      print('********************'+error.toString()+'********************');
    });

  }
  Future<void> saveProductsToDb(CategoryProvider provider,context)  {


    return _service.products//_service.user.uid
        .add(provider.dataTOFirestore)
        .then((value) {
      //return Navigator.pushNamed(context,'');
      provider.clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We have recived your details.'),
        ),
      );
      Navigator.pushReplacementNamed(
          context, MainScreen.id);
    },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error'),
        ),
      );
      print('Error: '+error.toString());
    });

  }

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);

    showConfrimDialog(){
      return showDialog(context: context,
          builder: (BuildContext context){
        return Flexible(
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Confirm',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text('Are you want to save below products'),
                  SizedBox(height: 10,),
                  Flexible(
                    child: ListTile(
                     leading:
                     Image.network(_provider.dataTOFirestore['images'][0],), //_provider.dataTOFirestore['images'][0].toString()
                     /* Container(
                       width: 30,
                       height: 30,
                       child: Image(image: _provider.dataTOFirestore['images'][0].toString(),),
                     ),*///Image.network(_provider.dataTOFirestore['images'][0].toString()),//_provider.dataTOFirestore['images'][0].toString()
                      title: Text(_provider.dataTOFirestore['type'],maxLines: 1,),
                      subtitle: Text(_provider.dataTOFirestore['rent']),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NeumorphicButton(
                        onPressed: (){
                          setState(() {
                            _loading=false;
                          });
                          Navigator.pop(context);
                        },
                        style: NeumorphicStyle(
                          border: NeumorphicBorder(color: Colors.teal),
                          color: Colors.transparent
                        ),
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 10,),
                      NeumorphicButton(
                        onPressed: (){

                          updateUser(_provider ,{
                        'contactDetails':{
                          'name':_nameController.text,
                          'mobile':_phoneController.text,
                          'email':_emailController.text,
                        }
                      }, context)
                          .whenComplete((){
                            setState(() {
                              _loading=false;
                            });
                            print('Completed');
                            Navigator.pushNamed(context, MainScreen.id);
                          });
                        },
                        style: NeumorphicStyle(
                            border: NeumorphicBorder(color: Colors.teal),
                        ),
                        child: Text('Confirm',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                  if(_loading)
                  SizedBox(height: 20,),
                  Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.teal
                        ),
                      )),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Review Your Details', style: TextStyle(color: Colors.black),),
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),

      body: Form(
        key: _formKey,
          child: FutureBuilder<DocumentSnapshot>(
            future: _service.getUserData(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.teal
                    ),
                  ),
                );
              }
              _nameController.text=snapshot.data['name'];
              _phoneController.text=snapshot.data['phone'];
              _emailController.text=snapshot.data['email'];
              _addressController.text=snapshot.data['address'];
              _countryController.text='+91';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    labelText: 'Your Name'
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Enter your name';
                                  }
                                  return null;
                                },
                              )),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text('Contact Details',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(child: TextFormField(
                            controller: _countryController,
                            enabled:false,
                            decoration: InputDecoration(
                                labelText: 'Country',
                                helperText: '+91',
                                counterText: '+91'),
                          )),
                          SizedBox(width: 10,),
                          Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  helperText: 'Enter contact mobile number',
                                ),
                                maxLength: 10,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Enter mobile number';
                                  }
                                  return null;
                                },
                              )),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  helperText: 'Enter contact email'
                              ),
                              validator: (value){
                                //final bool isValid = EmailValidator.validate(_emailController.text);
                                if(value.isEmpty || value== null){
                                  return 'Enter email';
                                }
                                /* if(value.isNotEmpty /*&& isValid == false*/){
                                return'Enter valid email';
                              }*/
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autofocus: false,
                              enabled: false,
                              minLines: 1,
                              maxLines: 4,
                              controller: _addressController,
                              keyboardType: TextInputType.text,
                              maxLength: 100,
                              decoration: InputDecoration(
                                  labelText: 'Address*',
                                  helperText: 'Contact address',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please complete required field';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute (
                                builder: (BuildContext context) {
                                  return HomeScreen();/*LocationScreen(
                                  locationChanging:// );*/
                                },
                              ));                            },
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    setState(() {
                      _loading=false;
                    });
                    showConfrimDialog();

                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter required fields'),
                    ),
                  );                },
                style: NeumorphicStyle(color: Colors.teal),
                child: Text('Confirm',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


