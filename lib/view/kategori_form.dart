import 'package:crud_coba/view/sub_category_form.dart';
import 'package:flutter/material.dart';
import 'package:crud_coba/database/database_helper.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kategori'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addCategory();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // Insert Category
  void _addCategory() async {
    String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      await DatabaseHelper().insertCategory(categoryName);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSubCategorie()),
      ); 
    } else {
      // Show info error / kaga
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Nama kategori tidak boleh kosong.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
