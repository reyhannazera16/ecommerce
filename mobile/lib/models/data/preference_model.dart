class PreferenceModel {
  final String key;
  String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PreferenceModel({required this.key, this.value, this.createdAt, this.updatedAt});

  factory PreferenceModel.fromMap(Map<String, dynamic> map) {
    return PreferenceModel(
      key: map['key'],
      value: map['value'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'value': value,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
