import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';

abstract class CensusRepository {
  Future<void> saveForm(ParentEntity parent);
  Future<List<ParentEntity>> getAllForms();
  Future<ParentEntity?> getFormById(int id);
  Future<void> deleteForm(int id);
}
