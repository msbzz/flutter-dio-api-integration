import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/listin_routes.dart';
import 'package:flutter_listin/_core/listin_theme.dart';
import 'package:flutter_listin/categories/model/category.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CategoryAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listin',
      debugShowCheckedModeBanner: false,
      theme: ListinTheme.mainTheme,
      initialRoute: ListinRoutes.auth,
      onGenerateRoute: ListinRoutes.generateRoute,
    );
  }
}
