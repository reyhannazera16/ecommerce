class ShippingAddressModel {
  final int? id;
  final String? address;
  final bool? isPrimary;

  ShippingAddressModel({this.id, this.address, this.isPrimary});

  factory ShippingAddressModel.fromMap(Map<String, dynamic> map) {
    return ShippingAddressModel(
      id: map['id'],
      address: map['address'],
      isPrimary: map['is_primary'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'is_primary': isPrimary == true ? 1 : 0,
    };
  }
}
