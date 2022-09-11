import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'database/databaseHelper.dart';
import 'database/userModel.dart';
import 'package:usedata/operation.dart';
import 'package:path_provider/path_provider.dart';
import 'database/databaseHelper.dart';

class SyncData extends StatefulWidget {
  const SyncData({Key? key}) : super(key: key);

  @override
  State<SyncData> createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> {
  final dbHelper = DatabaseHelper.instance;
  List<UserModel> userModel = [];
  late final Directory directory;
  int length = 0;
  late String i;
  void _getUsserInfo() async {
    final data = await DatabaseHelper.getUsers();
    directory = (await getExternalStorageDirectory())!;
    setState(() {
      if (data.length > 0) {
        userModel = data;
        length = userModel.length;
        // i = '${directory.path}/${userModel[0].image}';
      }
    });
    // print(i);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUsserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: (() {
              upload();
            }),
            child: const Text("Sync Data "),
          ),
          if (length > 0)
            SizedBox(width: 20, height: 20, child: Text("$length")
                // Image.file(File('$i')),
                )
        ],
      ),
    );
  }

  Future<void> upload() async {
    // Uint8List? bytes;
    // String img = "";
    for (var value in userModel) {
      // bytes = Io.File('${directory.path}/${value.image}').readAsBytesSync();
      // img = base64Encode(bytes);
      // print(img);

      const destination = 'images/';
      File file = File('${directory.path}/${value.image}');
      String baseame = basename(file.path);
      uploadUserData(value.name, value.age, value.gender, baseame);
      dbHelper.updateSync(1, value.id!);
      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child(basename(file.path));
        await ref.putFile(file);
      } catch (e) {
        print("error");
      }
    }
    // print("done");
  }

  // Future uploadImage() async {
  //   if (file == null) return;
  //   final destination = 'images/';
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('${getImage!.name}');
  //     await ref.putFile(file);
  //   } catch (e) {
  //     print("error");
  //   }
  // }
}
