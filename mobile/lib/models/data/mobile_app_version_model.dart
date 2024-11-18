class MobileAppVersionModel {
  int? id;
  String? name;
  String? description;

  MobileAppVersionModel({this.id, this.name, this.description});

  factory MobileAppVersionModel.fromMap(Map<String, dynamic> map) {
    return MobileAppVersionModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
