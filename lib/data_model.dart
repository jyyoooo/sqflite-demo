


// import 'package:flutter/material.dart';

class StudentModel {
  // BuildContext context;

  int? id;

  final String name;
     
  final String age;

  final String phone;

  StudentModel({required this.name,required this.age,this.id,required this.phone});

  static StudentModel fromMap(Map<String,Object?>map){
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final phone = map['phone'] as String;

    return StudentModel(id : id, name: name, age: age, phone: phone);
  }
} 