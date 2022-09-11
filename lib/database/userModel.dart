class UserColumn {
  static final List<String> values = [
    id,name,age,gender,image,sync
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String age = 'age';
  static const String gender = 'gender';
  static const String image = 'image';
  static const String sync = 'sync';
}


class UserModel {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String image;
  final int sync;

  UserModel(this.id, this.name, this.age, this.gender, this.image, this.sync);

  factory UserModel.fromMap(Map<String, dynamic> data) {
  return UserModel(
  data['id'], data['name'], data['age'], data['gender'], data['image'], data['sync']);
  }

  Map<String, Object> toMap(){
    return {
      UserColumn.id:id!,
      UserColumn.name:name,
      UserColumn.age:age,
      UserColumn.gender:gender,
      UserColumn.image:image,
      UserColumn.sync:sync
    };
  }
}