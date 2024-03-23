class SubCategory {
  int? id;
  String? subCategoryName;
  int? categoryId;

  SubCategory({this.id, this.subCategoryName, this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subCategoryName': subCategoryName,
      'category_id': categoryId,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'],
      subCategoryName: map['subCategoryName'],
      categoryId: map['category_id'],
    );
  }
}
