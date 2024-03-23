import 'package:crud_coba/view/link_form.dart';
import 'package:flutter/material.dart';
import 'package:crud_coba/database/database_helper.dart';
import 'package:crud_coba/view/data_page.dart';

class AddSubCategorie extends StatefulWidget {
  @override
  _addSubCategoryState createState() => _addSubCategoryState();
}

class _addSubCategoryState extends State<AddSubCategorie> {
  final TextEditingController _nameSubCategoryController =
      TextEditingController();

  String? _selectedCategory;
  List<Map<String, dynamic>> _categories = [];

  // ATI ATI 
  // enek sing category / categories

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // buat data category buat dropdown
  void _loadCategories() async {
    List<Map<String, dynamic>> categories =
        await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories[0]['nameCategory'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Buat Dropdown Category

            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category['nameCategory'],
                  child: Text(category['nameCategory']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString(); // ini yang kepilih 
                });
              },
              decoration: InputDecoration(
                labelText: 'Kategori',
              ),
            ),
            // Inpur Sub Category
            TextField(
              controller: _nameSubCategoryController,
              decoration: InputDecoration(
                labelText: 'Sub Category',
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addSubCategory();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // fungsi insert sub
  void _addSubCategory() async {
    String nameSubCategory = _nameSubCategoryController.text.trim();
    
    // ambil foreign key
    int categoryId = _categories.firstWhere(
        (category) => category['nameCategory'] == _selectedCategory)['id'];

    if (nameSubCategory.isNotEmpty) {
      await DatabaseHelper().insertSubCategory(nameSubCategory, categoryId);

      // Pindah ke form Link
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddLink()),
      );
    } else {
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Harus ada Sub Category'),
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
