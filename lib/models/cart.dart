import 'package:fake_store/models/product.dart';

class Cart {
  int? id;
  int? userId;
  DateTime? date;
  List<dynamic>? products;

  Cart({this.id, this.userId, this.date, this.products});

  factory Cart.fromJson(Map<String, dynamic> data) {
    return Cart(
      id: int.parse(data['id'].toString()),
      userId: data['userId'],
      date: DateTime.parse(data['date']),
      products: data['products'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "date": date,
      "products": products,
    };
  }
}
