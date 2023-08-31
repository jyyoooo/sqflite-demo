import 'package:database101/data_model.dart';
import 'package:database101/functions/db_functions.dart';
import 'package:flutter/material.dart';

class ListStudent extends StatelessWidget {
  const ListStudent({Key? key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder:
          (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (ctx, index) {
            final data = studentList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color.fromARGB(255, 182, 182, 182)),
                title: Text(data.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        updateStudentDialog(
                          context,
                          data.id!,
                          data.name,
                          data.age,
                          data.phone,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (data.id != null) {
                          deleteStudent(data.id!);
                        } else {
                          print('Invalid index');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const Divider();
          },
          itemCount: studentList.length,
        );
      },
    );
  }
}

Future<void> updateStudentDialog(
  BuildContext context,
  int studentId,
  String currentName,
  String currentAge,
  String currentPhone,
) async {
  TextEditingController nameController =
      TextEditingController(text: currentName);
  TextEditingController ageController = TextEditingController(text: currentAge);
  TextEditingController phoneController =
      TextEditingController(text: currentPhone);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'New Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'New Age'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'New Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newName = nameController.text;
              int newAge = int.tryParse(ageController.text) ?? 0;
              String newPhone = phoneController.text;

              if (newName.isEmpty || newAge <= 0 || newPhone.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Warning'),
                    content: const Text('Please fill in all fields.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                await updateStudent(
                    context, newName, newAge, newPhone, studentId);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
