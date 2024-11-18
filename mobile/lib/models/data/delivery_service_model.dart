class DeliveryServiceModel {
  final int? id;
  final String? name;

  const DeliveryServiceModel({this.id, this.name});

  factory DeliveryServiceModel.fromMap(Map<String, dynamic> map) {
    return DeliveryServiceModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }
}
