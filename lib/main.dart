import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:usedata/UserForm.dart';
import 'package:usedata/displayData.dart';

import 'UserInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Data Form")),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserFormPage()));
                }),
                child: const Text("New Form"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
              child: SyncData()
              // ElevatedButton(
              //   onPressed: (() {}),
              //   child: const Text("Sync Data"),
              // ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>const DisplayData()));
                }),
                child: const Text("Check Uploaded Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
