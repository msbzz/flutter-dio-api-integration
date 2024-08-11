import 'package:hive_flutter/hive_flutter.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String shortName;
 

  Category({
    required this.id,
    required this.name,
    required this.shortName,
  });

  Category.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        shortName = map["shortName"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "shortName": shortName,
    };
  }
}
