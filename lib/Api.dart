import 'User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Api{
  final String CollectionName='user';

  getUsers(){
    print("sachin");
    return Firestore.instance.collection(CollectionName).snapshots();
  }

  addUser(String addname){
    User user = User(addname);
    try{
      Firestore.instance.runTransaction(
          (Transaction transaction) async {
            await Firestore.instance.collection(CollectionName)
                .document().setData(user.toJson());
          }
      );
    }catch(e){
      print(e);
//      print(e.toString());
    }
  }

  update(User user,String newName){
    try{
      Firestore.instance.runTransaction(
              (Transaction transaction) async{
                await transaction.update(user.reference, {'name':newName});
              }
      );
    }catch(e){
//      print(e.toString());
      print(e);
    }
  }

  delete(User user){
    Firestore.instance.runTransaction(
        (Transaction transaction) async{
          await transaction.delete(user.reference);
        }
    );
  }



}