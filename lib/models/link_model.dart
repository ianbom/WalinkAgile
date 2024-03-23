class Link {
  int? id;
  String? link;
  String? nameLink;
  int? subCategoryId;
  DateTime? createdAt; // created mbe updated sek gaiso embo lapo aneh
  DateTime? updatedAt;

  Link({this.id, this.nameLink, this.link, this.subCategoryId, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
      'nameLink': nameLink,
      'subCategoryId': subCategoryId, 
      'createdAt' : createdAt, 
      'updatedAt' : updatedAt
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
        id: map['id'],
        link: map['link'],
        nameLink: map['nameLink'],
        subCategoryId: map['subCategoryId'], 
        createdAt : map['createdAt'], 
        updatedAt: map['updatedAt']);
  }
}
