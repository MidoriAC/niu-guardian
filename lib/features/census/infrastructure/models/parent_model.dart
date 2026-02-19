import 'package:isar/isar.dart';
import 'child_model.dart';

part 'parent_model.g.dart';

@collection
class ParentModel {
  Id id = Isar.autoIncrement;

  String? name;
  String? surname;

  @Index(type: IndexType.value)
  String? email;
  String? phone;
  DateTime? birthdate;
  String? documentId;

  String? civilStatus;
  String? gender;
  bool? hasHealthInsurance;
  bool? isEmployed;
  String? cityOfResidence;
  String? notes;

  List<ChildModel>? children;

  ParentModel({
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.birthdate,
    this.documentId,
    this.civilStatus,
    this.gender,
    this.hasHealthInsurance,
    this.isEmployed,
    this.cityOfResidence,
    this.notes,
    this.children,
  });
}
