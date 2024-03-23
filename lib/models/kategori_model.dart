class Category {
  int? id;
  String? nameCategory;

  Category({this.id, this.nameCategory});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameCategory': nameCategory,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      nameCategory: map['nameCategory'],
    );
  }
}
