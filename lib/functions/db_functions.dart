import 'package:database101/data_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

late Database _db;

Future<void> initializeDataBase() async {
  _db = await openDatabase('student.db', version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE student(id INTEGER PRIMARY KEY, name TEXT,age TEXT,phone TEXT)');
  });
  await getAllStudents();
} 

void addStudent(StudentModel value) async {
  await _db.rawInsert(
      'INSERT INTO student(name,age,phone) VALUES (?,?,?)', [value.name, value.age, value.phone]);
  getAllStudents();
}

Future<void> getAllStudents() async {
  final _values = await _db.rawQuery('SELECT * FROM student');
  print(_values);
  studentListNotifier.value.clear();

  _values.forEach((map) {
    final student = StudentModel.fromMap(map);
    studentListNotifier.value.add(student);
    studentListNotifier.notifyListeners();
  });

}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id=?', [id]);
      studentListNotifier.notifyListeners();

  getAllStudents();
}

Future<void> updateStudent(BuildContext context, newName, int newAge,String newPhone, int id) async {
  await _db.rawUpdate(
      'UPDATE student SET name = ?,age = ?,phone =? WHERE id = ?',[newName,newAge,newPhone,id]);
      studentListNotifier.notifyListeners();
      getAllStudents();
}
