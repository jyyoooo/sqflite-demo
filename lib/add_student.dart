import 'dart:developer';

import 'package:database101/data_model.dart';
import 'package:database101/functions/db_functions.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatelessWidget {
  AddStudent({Key? key}) : super(key: key);

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Add Student'),
      // ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Age',
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Phone number',
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addButton();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text('Fields are empty'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add student'),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'ListView',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: studentListNotifier,
                        builder: (
                          BuildContext ctx,
                          List<StudentModel> studentList,
                          Widget? child,
                        ) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              final data = studentList[index];
                              return ListTile(
                                hoverColor: Colors.amberAccent,
                                leading: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color.fromARGB(255, 197, 197, 197),
                                ),
                                title: Text(data.name),
                              );
                            },
                            itemCount: studentList.length,
                          );
                        },
                      ),
                    ),
                   const SizedBox(height: 5),
                    const Text(
                      'GridView',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: studentListNotifier,
                        builder: (
                          BuildContext ctx,
                          List<StudentModel> studentList,
                          Widget? child,
                        ) {
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 190,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (ctx, index) {
                              final data = studentList[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color.fromARGB(255, 197, 197, 197),
                                ),
                                title: Text(data.name),
                              );
                            },
                            itemCount: studentList.length,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addButton() async {
    final name = _nameCtrl.text.trim();
    final age = _ageCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty || age.isEmpty || phone.isEmpty) {
      return;
    }
    log('$name $age $phone');

    final student = StudentModel(name: name, age: age, phone: phone);

    addStudent(student);
  }
}
