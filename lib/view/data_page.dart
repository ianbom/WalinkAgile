import 'package:crud_coba/view/kategori_form.dart';
import 'package:flutter/material.dart';
import 'package:crud_coba/database/database_helper.dart';
import 'package:flutter/widgets.dart';

class AllItemsPage extends StatefulWidget {
  @override
  _AllItemsPageState createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  // nampung data
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _subCategories = [];
  List<Map<String, dynamic>> _link = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // load data semua
  void _loadData() async {
    List<Map<String, dynamic>> categories =
        await DatabaseHelper().getCategories();
    List<Map<String, dynamic>> subCategories =
        await DatabaseHelper().getSubCategory();
    List<Map<String, dynamic>> link = await DatabaseHelper().getLink();

    setState(() {
      _categories = categories;
      _subCategories = subCategories;
      _link = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Kategori Subkategori dan Link'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // button pindah ke add category
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              ).then((_) {
                _loadData();
              });
            },
          ),
        ],
      ),

      // listview Category
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kategori:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              _buildCategoriesList(),
              SizedBox(height: 16.0),
              // Listview Sub
              Text(
                'Subkategori:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Listview Link
              SizedBox(height: 8.0),
              _buildSubCategoriesList(),
              Text(
                'Link:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              _buildLinkList(),
            ],
          ),
        ],
      ),
    );
  }

  // Aku bingung fungsi2 iki mlebu controller / widget dadi tak gabung kene ae akwoakwowkpao

  // Widget Category

  Widget _buildCategoriesList() {
    return _categories.isEmpty
        ? Text('Tidak ada kategori.')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                    'ID: ${_categories[index]['id']}, Nama: ${_categories[index]['nameCategory']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditCategory(_categories[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(_categories[index]['id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  // Widget Sub Category

  Widget _buildSubCategoriesList() {
    return _subCategories.isEmpty
        ? Text('Tidak ada subkategori.')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _subCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                    'ID: ${_subCategories[index]['id']}, Nama: ${_subCategories[index]['nameSubCategory']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Kategori: ${_getCategoryName(_subCategories[index]['category_id'])}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditSubCategory(_subCategories[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteSubCategory(_subCategories[index]['id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  // Widget Link

  Widget _buildLinkList() {
    return _link.isEmpty
        ? Text('Tidak ada Links')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _link.length,
            itemBuilder: (BuildContext context, int index) {
              final link = _link[index];
              final subCategoryName = _getSubcategoryName(link['id']);
              return ListTile(
                title: Text(
                    'ID : ${link['id']}, Nama Link: ${link['nameLink']} Link:  ${link['link']}, Created at: ${link['createdAt']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Sub Category :  $subCategoryName')],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditLink(link);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteLink(link['id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  // Get Data Category untuk foreignKey Sub Category
  String _getCategoryName(int categoryId) {
    final category = _categories.firstWhere(
        (category) => category['id'] == categoryId,
        orElse: () => {'nameCategory': 'Unknown'});
    return category['nameCategory'];
  }

  // Get Data Sub Category untuk foreignKey Link
  _getSubcategoryName(int subCategoryId) {
    final subCategory = _subCategories.firstWhere(
        (subCategory) => subCategory['id'] == subCategoryId,
        orElse: () => {'nameSubCategory': 'Unknown'});
    return subCategory['nameSubCategory'];
  }

  // Edit Data Category
  // Category diedit Sub Category ikut teredit

  void _showEditCategory(Map<String, dynamic> category) {
    TextEditingController _editController =
        TextEditingController(text: category['nameCategory']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Kategori'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _editController.text.trim();
                if (newName.isNotEmpty) {
                  await DatabaseHelper().editCategory(category['id'], newName);
                  Navigator.of(context).pop();
                  _loadData(); // Refresh data after editing
                } else {
                  // Show error message if category name is empty
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
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Edit Data SubCategory
  // Sub diedit link ikut keedit
  void _showEditSubCategory(Map<String, dynamic> subCategory) {
    TextEditingController _editController =
        TextEditingController(text: subCategory['nameSubCategory']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Subkategori'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Nama Subkategori'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _editController.text.trim();
                if (newName.isNotEmpty) {
                  await DatabaseHelper()
                      .editSubCategory(subCategory['id'], newName);
                  Navigator.of(context).pop();
                  _loadData(); // Refresh data after editing
                } else {
                  // Show error message if subcategory name is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Nama subkategori tidak boleh kosong.'),
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
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Edit Data Link

  void _showEditLink(Map<String, dynamic> link) {
    TextEditingController _nameController =
        TextEditingController(text: link['nameLink']);
    TextEditingController _linkController =
        TextEditingController(text: link['link']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Link'),
              ),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(labelText: 'Link'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                String newLink = _linkController.text.trim();
                if (newName.isNotEmpty && newLink.isNotEmpty) {
                  await DatabaseHelper().editLink(link['id'], newName, newLink);
                  Navigator.of(context).pop();
                  _loadData(); // Refresh data after editing
                } else {
                  // Show error message if name or link is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Nama dan link tidak boleh kosong.'),
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
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Delete Data
  // Category dihapus Sub Category dan Link ikut terhapus

  void _deleteCategory(int categoryId) async {
    await DatabaseHelper().deleteCategory(categoryId);
    _loadData();
  }

  void _deleteSubCategory(int subcategoryId) async {
    await DatabaseHelper().deleteSubCategory(subcategoryId);
    _loadData();
  }

  void _deleteLink(int linkId) async {
    await DatabaseHelper().deleteLink(linkId);
    _loadData();
  }
}
