import 'package:flutter/material.dart';
import 'package:flutter_listin/categories/data/categories_box_handler.dart';
import 'package:flutter_listin/categories/model/category.dart';

class CategorySelectionModal extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategorySelectionModal({required this.onCategorySelected});

  @override
  _CategorySelectionModalState createState() => _CategorySelectionModalState();
}

class _CategorySelectionModalState extends State<CategorySelectionModal> {
  final CategoriesBoxHandler categoriesBoxHandler = CategoriesBoxHandler();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await categoriesBoxHandler.openBox();
    setState(() {
      categories = categoriesBoxHandler.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.5,
      child: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione uma categoria',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text('# ${category.name}'),
                        onTap: () {
                          widget.onCategorySelected(category.name);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

Future<void> showCategorySelectionModal({
  required BuildContext context,
  required Function(String) onCategorySelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
    ),
    builder: (context) {
      return CategorySelectionModal(onCategorySelected: onCategorySelected);
    },
  );
}
