import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usedata/UserInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  late String url = "";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(includeMetadataChanges: true),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;
          print(data.docs[1]['image']);
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                if (data.docs[index]['image'] == "") {
                } else {
                  _loadImage(data.docs[index]['image']);
                }
                return Card(
                  elevation: 3.0,
                  child: ListTile(
                    leading: data.docs[index]['image'] == ""
                        ? const Icon(
                            Icons.account_circle,
                            size: 60,
                          )
                        : url == ""
                            ? const Icon(
                                Icons.account_circle,
                                size: 60,
                              )
                            : Image.network(url),
                    //  _loadImage(context, data.docs[index]['image']),

                    // memory(
                    // const Base64Codec().decode(data.docs[index]['image'])
                    // ),
                    title: Text(data.docs[index]['name']),
                    subtitle: Text("gender: ${data.docs[index]['gender']}"),
                    trailing: Text("Age: ${data.docs[index]['age']}"),
                  ),
                );

                // UserInfo(name: data.docs[index]['name'], age: data.docs[index]['age'], gender: data.docs[index]['gender']);
              });
        },
      ),
    );
  }

  _loadImage(String image) async {
    // Image img;

    var urls = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$image')
        .getDownloadURL();
    // img = Image.network(
    //   url,
    //   fit: BoxFit.scaleDown,
    // );
    url = urls;
  }
}
