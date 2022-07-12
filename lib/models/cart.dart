import 'package:fake_store/models/product.dart';

class Cart {
  int? id;
  int? userId;
  DateTime? date;
  List<Product>? products;

  Cart({this.id, this.userId, this.date, this.products});
}
