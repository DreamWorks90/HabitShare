class User {
  int? id;
  String? name;
  String? description;
  String? frequency;
  String? time;

  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['description'] = description!;
    mapping['frequency'] = frequency!;
    mapping['time'] = time!;
  }
}
