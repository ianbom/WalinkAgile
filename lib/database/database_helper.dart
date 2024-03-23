import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // buat database
  // lek pgn data kosong ubah ae dbName, sembarang iso

  static Database? _database;
  static const String dbName = 'note_agile.db';
  static const int dbVersion = 1;

  // table Category
  // Ati ati namane rodok bedo2 mbe model
  static const String tableCategory = 'tableCategory';
  static const String columnId = 'id';
  static const String columnNameCategory = 'nameCategory';

  // table Sub Category
  static const String tableSubCategory = 'tableSubCategory';
  static const String columnSubCategoryId = 'id';
  static const String columnNameSubCategory = 'nameSubCategory';
  static const String columnCategoryId = 'category_id';

  // table Link
  static const String tableLink = 'tableLink';
  static const String columnLinkId = 'id';
  static const String columnLink = 'link';
  static const String columnNameLink = 'nameLink';
  static const String columnSubCategoryIdKey = 'subCategory_id';
  static const String columnCreatedAt = 'createdAt';
  static const String columnUpdatedAt = 'updatedAt';

  // Buka DB
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // inisialisasi DB
  initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) async {
        // Create category table
        await db.execute('''
          CREATE TABLE $tableCategory (
            $columnId INTEGER PRIMARY KEY,
            $columnNameCategory TEXT
          )
        ''');

        // Create Sub Catefory table
        await db.execute('''
          CREATE TABLE $tableSubCategory (
            $columnSubCategoryId INTEGER PRIMARY KEY,
            $columnNameSubCategory TEXT,
            $columnCategoryId INTEGER,
            FOREIGN KEY ($columnCategoryId) REFERENCES $tableCategory($columnCategoryId) ON DELETE CASCADE
          )
        ''');

        // create Link table
        // created mbe updated antara Datetime / string sek bingung error kabeh
        await db.execute('''
          CREATE TABLE $tableLink (
            $columnLinkId INTEGER PRIMARY KEY,
            $columnLink TEXT,
            $columnNameLink TEXT,
            $columnCreatedAt DATETIME, 
            $columnUpdatedAt DATETIME,
            $columnSubCategoryId INTEGER, 
            FOREIGN KEY ($columnSubCategoryId) REFERENCES $tableSubCategory($columnId) ON DELETE CASCADE
            
          )
        ''');
      },
      version: dbVersion,
    );
  }

  // CREATE DATA
  Future<int> insertCategory(String nameCategory) async {
    Database db = await database;
    return await db.insert(tableCategory, {columnNameCategory: nameCategory});
  }

  Future<int> insertSubCategory(String nameSubCategory, int categoryId) async {
    Database db = await database;
    return await db.insert(tableSubCategory, {
      columnNameSubCategory: nameSubCategory,
      columnCategoryId: categoryId,
    });
  }

  Future<int> insertLink(String link, String nameLink, int subCategoryId,
      DateTime createdAt) async {
    Database db = await database;
    return await db.insert(tableLink, {
      columnLink: link,
      columnNameLink: nameLink,
      columnSubCategoryId: subCategoryId
    });
  }

  // GET DATA
  Future<List<Map<String, dynamic>>> getCategories() async {
    Database db = await database;
    return await db.query(tableCategory);
  }

  Future<List<Map<String, dynamic>>> getSubCategory() async {
    Database db = await database;
    return await db.query(tableSubCategory);
  }

  Future<List<Map<String, dynamic>>> getLink() async {
    Database db = await database;
    return await db.query(tableLink);
  }

  // EDIT DATA
  Future<void> editCategory(int id, String newName) async {
    Database db = await database;
    await db.update(
      tableCategory,
      {columnNameCategory: newName},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> editSubCategory(int id, String newName) async {
    Database db = await database;
    await db.update(
      tableSubCategory,
      {columnNameSubCategory: newName},
      where: '$columnSubCategoryId = ?',
      whereArgs: [id],
    );
  }

  Future<void> editLink(int id, String newName, String newLink) async {
    Database db = await database;
    await db.update(
      tableLink,
      {
        columnNameLink: newName,
        columnLink: newLink,
      },
      where: '$columnLinkId = ?',
      whereArgs: [id],
    );
  }

  // DELETE DATA
  Future<void> deleteCategory(int id) async {
    Database db = await database;

    await db.delete(
      tableLink,
      where: '$columnLinkId = ?',
      whereArgs: [id],
    );

    await db.delete(
      tableSubCategory,
      where: '$columnCategoryId = ?',
      whereArgs: [id],
    );
    await db.delete(
      tableCategory,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSubCategory(int id) async {
    Database db = await database;
    await db.delete(
      tableLink,
      where: '$columnSubCategoryId = ?',
      whereArgs: [id],
    );

    await db.delete(
      tableSubCategory,
      where: '$columnSubCategoryId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteLink(int id) async {
    Database db = await database;
    await db.delete(tableLink, where: '$columnLinkId = ?', whereArgs: [id]);
  }

  // Method to close database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
