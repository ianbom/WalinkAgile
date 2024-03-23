import 'package:crud_coba/view/data_page.dart';
import 'package:flutter/material.dart';

// import 'package:crud_coba/models/link_model.dart';
import 'package:crud_coba/database/database_helper.dart';

class AddLink extends StatefulWidget {
  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final TextEditingController _nameLinkController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String? _selectedSubCategory;
  List<Map<String, dynamic>> _subCategory = [];
  
  List<Map<String, dynamic>> _categories = []; // Ga perlu harus e


  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadSubCategories();
  }
    // buat load data sub

  void _loadCategories() async {  // lupakan ae iki
    List<Map<String, dynamic>> categories =     
        await DatabaseHelper().getCategories();
    setState(() {});
  }

  void _loadSubCategories() async {
    List<Map<String, dynamic>> subCategory =
        await DatabaseHelper().getSubCategory();
    setState(() {
      _subCategory = subCategory;
      if (_subCategory.isNotEmpty) {
        _selectedSubCategory = _subCategory[0]['nameSubCategory'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Link'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // dropdown sub cat
            DropdownButtonFormField(
              value: _selectedSubCategory,
              items: _subCategory.map((subCategory) {
                return DropdownMenuItem(
                  value: subCategory['nameSubCategory'],
                  child: Text(subCategory['nameSubCategory']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubCategory = value.toString(); // yang diselect
                });
              },
              decoration: InputDecoration(
                labelText: 'Sub Kategori',
              ),
            ),

            // input nama link
            TextField(
              controller: _nameLinkController,
              decoration: InputDecoration(
                labelText: 'Nama Link',
              ),
            ),
            SizedBox(height: 16.0),

            // input url link
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'URL Link',
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),

            // button insert link
            ElevatedButton(
              onPressed: () {
                _addLink();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // fungsi insert link
  void _addLink() async {
    String nameLink = _nameLinkController.text.trim();
    String link = _linkController.text.trim();
    DateTime createdAt = DateTime.now();  // iki embo lapo gaiso aneh
    int subCategoryId = _subCategory.firstWhere((subCategory) =>      
        subCategory['nameSubCategory'] == (_selectedSubCategory ?? ''))['id'];

    if (nameLink.isNotEmpty) {
      //urutan paramater ngaruh anjay 
      await DatabaseHelper()
          .insertLink(nameLink, link, subCategoryId, createdAt);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllItemsPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('nama link dan url tidak boleh kosong.'),
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
