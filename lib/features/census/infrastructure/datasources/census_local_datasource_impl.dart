import 'package:isar/isar.dart';
import '../../domain/datasources/census_datasource.dart';
import '../models/parent_model.dart';
import '../../domain/entities/parent_entity.dart';
import '../mappers/census_mapper.dart';

class CensusLocalDatasourceImpl implements CensusDatasource {
  final Isar isar;

  CensusLocalDatasourceImpl(this.isar);

  @override
  Future<void> saveForm(ParentEntity parentEntity) async {
    final parentModel = CensusMapper.parentToModel(parentEntity);

    await isar.writeTxn(() async {
      await isar.parentModels.put(parentModel);
    });
  }

  @override
  Future<List<ParentEntity>> getAllForms() async {
    final models = await isar.parentModels.where().findAll();
    return models.map((m) => CensusMapper.parentToEntity(m)).toList();
  }

  @override
  Future<void> deleteForm(int id) async {
    await isar.writeTxn(() async {
      await isar.parentModels.delete(id);
    });
  }
}
