//only for cars
import 'dart:io';
import 'package:galleryimage/galleryimage.dart';
import 'package:home_rent_app/forms/user_review_screen.dart';
import 'package:home_rent_app/provider/cat_provider.dart';
import 'package:home_rent_app/screens/firestore_service.dart';
import 'package:home_rent_app/widgets/imagePicker_widget.dart';
import 'package:provider/provider.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_storage/firebase_storage.dart';


class SellerCarForm extends StatefulWidget {
  const SellerCarForm({Key key}) : super(key: key);
  static const String id = 'car-form';

  @override
  _SellerCarFormState createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {





  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseService _service = FirebaseService();
  String  downloadUrl;
  var _titleController=TextEditingController();
  var _typeController=TextEditingController();
  var _floorNoController=TextEditingController();
  var _rentController=TextEditingController();
  var _maintenanceController=TextEditingController();
  var _furnitureController=TextEditingController();
  var _noOfBathRoomController=TextEditingController();
  var _desController=TextEditingController();
  var _addressController=TextEditingController();

  String _address ='';



  validate(CategoryProvider provider) {
    if (_formKey.currentState.validate()) {
      if(_formKey.currentState.validate()){
        if(provider.urlList.isNotEmpty){
          provider.dataTOFirestore.addAll({
            'category':provider.selectedCategory,
            'subCat': provider.selectedSubCat,
            'type':_typeController.text,
            'title':_titleController.text,
            'rent':_rentController.text,
            'maintenace':_maintenanceController.text,
            'furniture': _furnitureController.text,
            'noOfBathroom': _noOfBathRoomController.text,
            'description': _desController.text,
            'images':provider.urlList,
            'postedAt':DateTime.now().microsecondsSinceEpoch,
            if(provider.selectedCategory=="Flats")
              'floorNO': _floorNoController.text,

            /*{
              'catName': provider.selectedCategory
            }*/
          });
          print(provider.dataTOFirestore);
          Navigator.pushNamed(context, UserReviewScreen.id);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('images not uploaded'),
            ),
          );
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields...'),
        ),
      );
    }
  }

  List<String>_furniture=[
    'With Furniture','Without Furniture'
  ];
  @override
  void didChangeDependency(){
    var _catProvider = Provider.of<CategoryProvider>(context);
    setState(() {
      _titleController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['title'];
      _typeController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['type'];
      _rentController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['rent'];
      _maintenanceController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['maintenance'];
      _noOfBathRoomController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['noOfBathroom'];
      _furnitureController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['furniture'];
      _desController.text=_catProvider.dataTOFirestore.isEmpty ? null :_catProvider.dataTOFirestore['description'];
     });
    super.didChangeDependencies();

  }
  /*void initState(){
    _service.getUserData().then((value) => {
      _addressController.text=value['address']
    });
    super.initState(
    );
  }*/
 /* List<String>_noOfBathRoom=[
    '1','2','3,
  ];*/

    @override
    Widget build(BuildContext context) {

      var _catProvider = Provider.of<CategoryProvider>(context);

      Future<String> getURL() async{
        try {
          //await FirebaseStorage.instance.ref(imageName).putFile(file);
          /*downloadUrl = await FirebaseStorage.instance
            .ref(imageName)
            .getDownloadURL();*/
          if(downloadUrl!=null){
            setState(() {
              // _image=null;
              _catProvider.getImages(downloadUrl);
            });
          }
        } on FirebaseException catch (e) {
          String error = e.code;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cancelled'),
            ),
          );
          // e.g, e.code == 'canceled'
        }
        return downloadUrl;
      }


      Widget _appBar(title,fieldValue) {
        return AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          shape: Border(bottom: BorderSide(color: Colors.grey)),
          title: Text('$title > $fieldValue',
            style: TextStyle(color: Colors.black, fontSize: 14),),
        );
      }
      Widget _houseTypeList() {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(_catProvider.selectedCategory,'Types'),
              Expanded(
                child: ListView.builder(
                    itemCount: _catProvider.doc['type'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _typeController.text=_catProvider.doc['type'][index];
                          });
                          Navigator.pop(context);
                        },
                        title: Text(_catProvider.doc['type'][index]),
                      );
                    }),
              ),
            ],
          ),
        );
      }
      Widget _furListView ({fieldValue,list,textController}){


        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(_catProvider.selectedCategory,fieldValue),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context,int index){
                return ListTile(
                  onTap: (){
                    textController.text = list[index];
                    Navigator.pop(context);
                  },
                  title: Text(list[index]),
                );
              }),
            ],
          ),
        );
      };

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: Text(
            'Add some details', style: TextStyle(color: Colors.black),),
          shape: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_catProvider.selectedCategory,style: TextStyle(fontWeight: FontWeight.bold),),
                    TextFormField(
                      autofocus: false,
                      controller: _titleController,
                      minLines: 1,
                      maxLines: 30,
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      decoration: InputDecoration(
                          labelText: 'Title*',
                          helperText: 'Include house name or any title'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context, builder: (BuildContext context) {
                          return _houseTypeList();
                        });
                      },
                      child: TextFormField(
                        controller: _typeController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Type*'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please complete required field';
                          }
                          return null;
                        },
                      ),
                    ),
                    if(_catProvider.selectedCategory=="Flats")
                    TextFormField(
                      autofocus: false,
                      controller: _floorNoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Floor No*',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _rentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Rent*',
                        prefixText: 'Rs'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _maintenanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Maintenance*',
                        prefixText: 'Rs'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _noOfBathRoomController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'No of Bathroom*',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return _furListView(fieldValue: 'Furniture',list: _furniture,textController: _furnitureController);
                        });
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: _furnitureController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Furniture*',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please complete required field';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _desController,
                      minLines: 1,
                      maxLines: 30,
                      keyboardType: TextInputType.text,
                      maxLength: 5000,
                      decoration: InputDecoration(
                        labelText: 'Description*',
                        helperText: 'Include house condition and other facilities'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    Divider(color: Colors.grey,),
                    /*TextFormField(
                      autofocus: false,
                      controller: _addressController,
                      keyboardType: TextInputType.number,
                      maxLength: 100,
                      decoration: InputDecoration(
                          labelText: 'Address*',
                          counterText: 'Seller Address'
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                    Divider(color: Colors.grey,),*/
                    if(_catProvider.urlList.length>0)
                    Container(
                      width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _catProvider.urlList.length==0?Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('No Image Selected',
                            textAlign: TextAlign.center,
                          ),
                        ):
                        GalleryImage(
                          imageUrls: _catProvider.urlList,
                        )
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: InkWell(
                          onTap: (){
                            //notifyListeners();
                            setState(() {

                            });
                            getURL();
                            showDialog(context: context,builder: (BuildContext context){
                              return ImagePickerWidget();
                            });

                          },
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              border: NeumorphicBorder(
                                color: Colors.teal
                              )
                            ),
                            child: Container(
                              height: 40,
                              child: Center(child: Text(_catProvider.urlList.length>0
                                  ?'Upload more images'
                                  :'Upload Images',),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70,),

                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  style: NeumorphicStyle(color: Colors.blueAccent),
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () {
                    validate(_catProvider);
                    print(_catProvider.dataTOFirestore);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }




/*class SellerCarForm extends StatefulWidget {
  //const SellerCarForm({Key? key}) : super(key: key);

}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }*/
