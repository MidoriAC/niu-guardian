import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';

abstract class CensusDatasource {
  Future<void> saveForm(ParentEntity parent);
  Future<List<ParentEntity>> getAllForms();
  Future<void> deleteForm(int id);
}
