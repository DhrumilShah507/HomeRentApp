import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:home_rent_app/provider/cat_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  String  downloadUrl;
  File _image;
  bool uploading=false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);

    Future<String> uploadFile() async {
      File file = File(_image.path);
      String imageName ='productImage/${DateTime.now().microsecondsSinceEpoch}';

      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl = await FirebaseStorage.instance
            .ref(imageName)
            .getDownloadURL();
        if(downloadUrl!=null){
          setState(() {
            _image=null;
            _provider.getImages(downloadUrl);
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

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Upload Images',
              style: TextStyle(
                color: Colors.black
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if(_image!=null)
                    Positioned(
                      right: 0,
                      child: IconButton(icon: Icon(Icons.clear),
                      onPressed: () {
                      setState(() {
                        _image=null;
                      });
                      },),),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image==null ? Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: Colors.grey,
                        ): Image.file(_image),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                if(_provider.urlList.length>0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                    child: GalleryImage(
                        imageUrls: _provider.urlList,
                    )
                ),
                SizedBox(height: 20,),
                if(_image!=null)
                Row(
                  children: [
                    Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.green),
                          onPressed: (){
                            setState(() {
                              uploading=true;
                              uploadFile().then((url){
                                if(url!=null){
                                  uploading=false;
                                }
                              });
                            });
                          },
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                          ),
                        )),
                    SizedBox(height: 20,),
                    Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.red),
                          onPressed: (){
                          },
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(
                          color: Colors.teal
                        ),
                        child: Text(
                          _provider.urlList.length>0
                              ?'Upload more images'
                              :'Upload Images',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          if(uploading)
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          )
        ],
      ),
    );
  }
}
