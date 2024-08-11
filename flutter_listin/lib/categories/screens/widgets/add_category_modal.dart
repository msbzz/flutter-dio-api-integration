import 'package:flutter/material.dart';
import 'package:flutter_listin/categories/data/categories_box_handler.dart';
import 'package:flutter_listin/categories/model/category.dart';

class AddCategoryModal extends StatefulWidget {
  final Function() refresh;
  final CategoriesBoxHandler categoriesBoxHandler;

  const AddCategoryModal({super.key, 
  required this.refresh,
  required this.categoriesBoxHandler });

  @override
  _AddCategoryModalState createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  String _categoryName = '';
  String _shortName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar categoria'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Categoria'),
              onChanged: (value) {
                setState(() {
                  _categoryName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome da categoria';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Short Name'),
              onChanged: (value) {
                setState(() {
                  _shortName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome resumido';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCategory = Category(
                id: DateTime.now().toString(),
                name: _categoryName,
                shortName: _shortName,
              );
              widget.categoriesBoxHandler.insertCategory(newCategory);
              widget.refresh();
              Navigator.of(context).pop();
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
