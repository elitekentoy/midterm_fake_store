import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api_response.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final String categoryName;

  const ProductsByCategoryScreen({Key? key, required this.categoryName})
      : super(key: key);
  ApiService get service => GetIt.I<ApiService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
        future: service.getProductsByCategory(categoryName),
        builder: (BuildContext context,
            AsyncSnapshot<APIResponse<List<Product>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(thickness: 1),
            itemCount: products.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text('[title]'),
                leading: Image.network(
                  '[image]',
                  height: 50,
                  width: 50,
                ),
                subtitle: Text('\$price'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(id: productId),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
