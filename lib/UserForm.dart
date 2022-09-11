import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dataform/userData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io' as Io;
import 'package:image_picker/image_picker.dart';
import 'package:usedata/database/databaseHelper.dart';
import 'package:usedata/database/userModel.dart';
import 'package:usedata/main.dart';
import 'package:usedata/operation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({Key? key}) : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  late String name;
  late int age;
  String gender = 'Male';
  String image = "";
  String firebaseImage = "";
  int sync = 0;
  XFile? getImage;
  // Uint8List? bytes;
  DateFormat dateFormat = DateFormat("yyyy_MM_dd_HHmmss");
  late File file;

  final List<String> _gender = ['Male', 'Female', 'Other'];

  final dbHelper = DatabaseHelper.instance;
  // StorageRefrence storageRefrence =
  late final Directory directory;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> captureImage() async {
    String string = dateFormat.format(DateTime.now());
    final ImagePicker _picker = ImagePicker();
    final XFile? choosedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (choosedImage != null) {
      try {
        directory = (await getExternalStorageDirectory())!;
        if (directory != null) {
          final bytes = Io.File(choosedImage.path).readAsBytesSync();
          firebaseImage = base64Encode(bytes);
          file = await File(choosedImage.path)
              .copy('${directory.path}/${choosedImage.name}');
          // print(file.path);

        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      getImage = choosedImage;
      image = choosedImage!.name;
      // firebaseImage = i
      // print(fileName);
    });
  }

  Future uploadImage() async {
    print(file);
    if (file == null) return;
    final destination = 'images/';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('${getImage!.name}');
      await ref.putFile(file);
    } catch (e) {
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Form"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
                width: 250,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                  onChanged: ((value) => setState(() {
                        name = value;
                      })),
                ),
              ),
              Container(
                height: 90,
                width: 250,
                child: TextFormField(
                  decoration: new InputDecoration(labelText: 'Age'),
                  onChanged: ((value) => setState(() {
                        age = int.parse(value);
                      })),
                ),
              ),
              Container(
                child: Container(
                  height: 90,
                  width: 200,
                  child: DropdownButton(
                    hint: Text("Select Gender"),
                    isExpanded: true,
                    focusColor: Colors.red,
                    dropdownColor: Colors.red[100],
                    value: gender,
                    items: _gender
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Center(child: Text(e)),
                            ))
                        .toList(),
                    onChanged: (String? e) {
                      setState(() {
                        gender = e!;
                      });
                    },
                  ),
                ),
              ),
              // ImageSelector(),
              Container(
                  child: Stack(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      height: 100,
                      child: CircleAvatar(
                        child: image != ""
                            ? Image.file(File(getImage!.path))
                            : const Icon(Icons.person),
                      ),
                    ),
                    onTap: () {
                      captureImage();
                    },
                  ),
                ],
              )),

              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: (() {
                    uploadUserData(name, age, gender, image);
                    uploadImage();
                    _insert(name, age, gender, image, sync);

                    // final newuser = FormData(1, name, age, gender, 'hhd');
                    // repository
                    //     .addPet(newuser)
                    //     .then((value) => print("user Added"))
                    //     .catchError((error) => print('Failed to add :$users'));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  }),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insert(
      String name, int age, String gender, String image, int sync) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columName: name,
      DatabaseHelper.columnAge: age,
      DatabaseHelper.columanGender: gender,
      DatabaseHelper.columanImage: image,
      DatabaseHelper.columanSync: sync
    };
    UserModel userModel = UserModel.fromMap(row);
    final id = await dbHelper.insert(userModel);
    print(id);
  }
}
