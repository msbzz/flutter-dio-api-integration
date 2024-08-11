import 'package:flutter_listin/products/model/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductsBoxHandler{
  late Box _box;

  Future<void> openBox(String ListinId) async{
    _box = await Hive.openBox(ListinId);
  }

  Future<void> closeBox() async{
     return _box.close();
  }

  Future<int>insertProduct(Product product){
    return _box.add(product);
  }

  List<Product> getProducts(){
    return _box.values.map((elemento)=>elemento as Product).toList();
  }

  Future<void> updateProduct(Product product)async {
    return product.save();
  }

  Future<void>removeProduct(Product product) async{
    return _box.delete(product.key);
  }
}