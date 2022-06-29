
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_rent_app/screens/firestore_service.dart';


class CategoryProvider with ChangeNotifier{
  FirebaseService _service = FirebaseService();
  DocumentSnapshot doc;
  DocumentSnapshot userDetails;
  String selectedCategory;
  String selectedSubCat;
  List<String> urlList =[];
  Map<String,dynamic> dataTOFirestore ={};

  getCategory(selectedCat){
    this.selectedCategory=selectedCat;
    notifyListeners();
  }
  getSubCategory(selectedsubCat){
    this.selectedSubCat= selectedsubCat;
    notifyListeners();
  }
  getCatSnapshot(snapshot){
    this.doc =snapshot;
    notifyListeners();
  }
  getImages(url){
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data){
    this.dataTOFirestore=data;
    notifyListeners();
  }

  getUserDetails(){
    _service.getUserData().then((value){
      this.userDetails=value;
      notifyListeners();
    });
  }

  clearData(){
    this.urlList=[];
    dataTOFirestore={};
    notifyListeners();
  }

}