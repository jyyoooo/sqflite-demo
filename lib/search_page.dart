import 'package:flutter/material.dart';
import 'package:database101/data_model.dart';
import 'package:database101/functions/db_functions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentModel> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = studentListNotifier.value;
  }

  void _filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredStudents = studentListNotifier.value;
      });
    } else {
      setState(() {
        _filteredStudents = studentListNotifier.value
            .where((student) =>
                student.name.toLowerCase().contains(query.toLowerCase()) ||
                student.phone.contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: _filterStudents,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox.square(dimension: 10),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterStudents('');
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder(
                valueListenable: studentListNotifier,
                builder: (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
                  return SizedBox(
                    height: 515,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final data = _filteredStudents[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 90,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(''),
                                radius: 25,
                                backgroundColor: Color.fromARGB(255, 204, 204, 204),
                              ),
                              title: Text(data.name),
                              subtitle: Column(
                                children: [
                                  Text(' Age: ${data.age}'),
                                  Text(' Phone: ${data.phone}')
                                  
                                ],
                              ),
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
                                    icon: const Icon(Icons.edit,color: Colors.blue,),
                                  ),
                                  IconButton(
                                    icon:Icon(
                                      Icons.delete,
                                      color: Colors.red[400],
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Student'),
                                          content: const Text(
                                              'Are you sure you want to delete this student?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (data.id != null) {
                                                  await deleteStudent(data.id!);
                                                } else {
                                                  print('invalid index');
                                                }
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: _filteredStudents.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
      return SingleChildScrollView(
        child: AlertDialog(
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
        ),
      );
    },
  );
}
