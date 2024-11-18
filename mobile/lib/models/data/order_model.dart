import 'order_status_model.dart';

class OrderModel {
  String? id;
  String? productId;
  String? productName;
  String? buyerId;
  String? buyerName;
  String? buyerPhoto;
  String? shopId;
  String? shopName;
  String? status;
  String? trackingNumber;
  String? paymentMethodId;
  String? paymentMethodName;
  String? deliveryServiceId;
  String? deliveryServiceName;
  String? shippingAddressId;
  String? shippingAddress;
  int? qty;
  int? price;
  DateTime? createdAt;

  OrderModel({
    this.id,
    this.productId,
    this.productName,
    this.buyerId,
    this.buyerName,
    this.buyerPhoto,
    this.shopId,
    this.shopName,
    this.status = 'pending',
    this.trackingNumber,
    this.paymentMethodId,
    this.paymentMethodName,
    this.deliveryServiceId,
    this.deliveryServiceName,
    this.shippingAddressId,
    this.shippingAddress,
    this.qty,
    this.price,
    this.createdAt,
  }) {
    assert(qty != null, 'Quantity tidak boleh null');
    assert(price != null, 'Price tidak boleh null');
    assert(status != null, 'Status tidak boleh null');
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    print('Debug fromMap - Raw data: $map');
    
    int? quantity;
    if (map['qty'] != null) {
      quantity = map['qty'] is int ? map['qty'] : int.tryParse(map['qty'].toString());
    }
    
    int? priceValue;
    if (map['price'] != null) {
      priceValue = map['price'] is int ? map['price'] : int.tryParse(map['price'].toString());
    }
    
    String statusValue = map['status'] ?? 'pending';
    
    return OrderModel(
      id: map['id']?.toString(),
      productId: map['product_id']?.toString(),
      productName: map['product_name'],
      buyerId: map['buyer_id']?.toString() ?? map['user_id']?.toString(),
      buyerName: map['buyer_name'] ?? map['user_name'],
      buyerPhoto: map['buyer_photo'],
      shopId: map['shop_id']?.toString(),
      shopName: map['shop_name'],
      status: statusValue,
      trackingNumber: map['tracking_number'],
      paymentMethodId: map['payment_method_id']?.toString(),
      paymentMethodName: map['payment_method_name'],
      deliveryServiceId: map['delivery_service_id']?.toString(),
      deliveryServiceName: map['delivery_service_name'],
      shippingAddressId: map['shipping_address_id']?.toString(),
      shippingAddress: map['shipping_address'],
      qty: quantity ?? 1,
      price: priceValue ?? 0,
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'buyer_photo': buyerPhoto,
      'shop_id': shopId,
      'shop_name': shopName,
      'status': status,
      'tracking_number': trackingNumber,
      'payment_method_id': paymentMethodId,
      'payment_method_name': paymentMethodName,
      'delivery_service_id': deliveryServiceId,
      'delivery_service_name': deliveryServiceName,
      'shipping_address_id': shippingAddressId,
      'shipping_address': shippingAddress,
      'qty': qty,
      'price': price,
      'created_at': createdAt?.toIso8601String(),
    };
    
    print('Debug - OrderModel.toMap():');
    print(map);
    return map;
  }
}
