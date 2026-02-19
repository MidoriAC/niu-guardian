import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niu_guardian/core/providers/isar_provider.dart';
import 'package:niu_guardian/features/census/domain/repositories/census_repository.dart';
import 'package:niu_guardian/features/census/infrastructure/datasources/census_local_datasource_impl.dart';
import 'package:niu_guardian/features/census/infrastructure/repositories/census_repository_impl.dart';

final censusDatasourceProvider = Provider<CensusLocalDatasourceImpl>((ref) {
  final isarDb = ref.watch(isarProvider);

  return CensusLocalDatasourceImpl(isarDb.requireValue);
});

final censusRepositoryProvider = Provider<CensusRepository>((ref) {
  final datasource = ref.watch(censusDatasourceProvider);
  return CensusRepositoryImpl(datasource);
});
