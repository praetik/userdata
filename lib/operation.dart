import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadUserData(String name, int age, String gender, String image) async {
  await FirebaseFirestore.instance.collection("users").add({
    'name':name,
    'age':age,
    'gender':gender,
    'image':image,
  });
  //     .then((value) => {print("user Added");
  //     // return true
  //     })
  //     .catchError((error) {
  //   print('Failed to add :User');
  //   return false;
  // });
}