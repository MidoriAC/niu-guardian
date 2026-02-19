import 'package:isar/isar.dart';
import 'package:niu_guardian/features/census/domain/entities/child_entity.dart';
import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';
import 'package:niu_guardian/features/census/infrastructure/models/child_model.dart';
import 'package:niu_guardian/features/census/infrastructure/models/parent_model.dart';

class CensusMapper {
  static ParentModel parentToModel(ParentEntity parentEntity) {
    return ParentModel()
      ..id = parentEntity.id ?? Isar.autoIncrement
      ..name = parentEntity.name
      ..surname = parentEntity.surname
      ..email = parentEntity.email
      ..phone = parentEntity.phone
      ..birthdate = parentEntity.birthdate
      ..documentId = parentEntity.documentId
      ..civilStatus = parentEntity.civilStatus
      ..gender = parentEntity.gender
      ..hasHealthInsurance = parentEntity.hasHealthInsurance
      ..isEmployed = parentEntity.isEmployed
      ..cityOfResidence = parentEntity.cityOfResidence
      ..notes = parentEntity.notes
      ..children =
          parentEntity.children.map((child) => childToModel(child)).toList();
  }

  static ChildModel childToModel(ChildEntity childEntity) {
    return ChildModel(
      name: childEntity.name,
      surname: childEntity.surname,
      birthdate: childEntity.birthdate,
      age: childEntity.age,
      hairColor: childEntity.hairColor,
      uniqueCode: childEntity.uniqueCode,
    );
  }

  static ParentEntity parentToEntity(ParentModel parentModel) {
    return ParentEntity(
      id: parentModel.id,
      name: parentModel.name!,
      surname: parentModel.surname!,
      email: parentModel.email!,
      phone: parentModel.phone!,
      birthdate: parentModel.birthdate!,
      documentId: parentModel.documentId!,
      civilStatus: parentModel.civilStatus!,
      gender: parentModel.gender!,
      hasHealthInsurance: parentModel.hasHealthInsurance!,
      isEmployed: parentModel.isEmployed!,
      cityOfResidence: parentModel.cityOfResidence!,
      notes: parentModel.notes!,
      children:
          parentModel.children?.map((child) => childToEntity(child)).toList() ??
              [],
    );
  }

  static ChildEntity childToEntity(ChildModel childModel) {
    return ChildEntity(
      name: childModel.name!,
      surname: childModel.surname!,
      birthdate: childModel.birthdate!,
      age: childModel.age!,
      hairColor: childModel.hairColor!,
      uniqueCode: childModel.uniqueCode!,
    );
  }
}
