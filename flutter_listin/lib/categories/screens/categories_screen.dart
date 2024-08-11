import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/listin_routes.dart';
import 'package:flutter_listin/categories/data/categories_box_handler.dart';
import 'package:flutter_listin/categories/model/category.dart';
import 'package:flutter_listin/categories/screens/widgets/add_category_modal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesBoxHandler _categoriesBoxHandler = CategoriesBoxHandler();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  Future<void> _initializeCategories() async {
    await _categoriesBoxHandler.openBox();  
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      categories = _categoriesBoxHandler.getCategories();  
    });
  }

 
  void _deleteCategory(int index) async {
    final category = categories[index];
    await _categoriesBoxHandler.removeCategory(category);  
    _loadCategories(); 
  }

  @override
  void dispose() {
    _categoriesBoxHandler.closeBox();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas categorias'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, ListinRoutes.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddCategoryModal(refresh:_loadCategories,categoriesBoxHandler:_categoriesBoxHandler);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: categories.isEmpty
          ? const Center(child: Text('Nenhuma categoria encontrada'))
          : Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text('# ${category.name}'),
                    subtitle: Text(category.shortName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(index);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
