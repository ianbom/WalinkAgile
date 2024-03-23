import 'package:crud_coba/view/data_page.dart';
import 'package:crud_coba/view/kategori_form.dart';
import 'package:crud_coba/view/link_form.dart';
import 'package:crud_coba/view/sub_category_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp sebagai root widget
    return MaterialApp(
      home:
          AllItemsPage(), // Menggunakan halaman AddCategoryPage sebagai halaman utama
    );
  }
}
