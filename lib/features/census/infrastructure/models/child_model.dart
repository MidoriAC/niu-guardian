import 'package:isar/isar.dart';

part 'child_model.g.dart';

@embedded
class ChildModel {
  String? name;
  String? surname;
  DateTime? birthdate;
  int? age;
  String? hairColor;

  String? uniqueCode;

  ChildModel({
    this.name,
    this.surname,
    this.birthdate,
    this.age,
    this.hairColor,
    this.uniqueCode,
  });
}
