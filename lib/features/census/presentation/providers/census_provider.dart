import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niu_guardian/core/providers/isar_provider.dart';
import 'package:niu_guardian/features/census/domain/repositories/census_repository.dart';
import 'package:niu_guardian/features/census/infrastructure/datasources/census_local_datasource_impl.dart';
import 'package:niu_guardian/features/census/infrastructure/repositories/census_repository_impl.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_notifier.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_state.dart';

final censusDatasourceProvider = Provider<CensusLocalDatasourceImpl>((ref) {
  final isarDb = ref.watch(isarProvider);

  return CensusLocalDatasourceImpl(isarDb.requireValue);
});

final censusRepositoryProvider = Provider<CensusRepository>((ref) {
  final datasource = ref.watch(censusDatasourceProvider);
  return CensusRepositoryImpl(datasource);
});

final censusProvider =
    StateNotifierProvider<CensusNotifier, CensusState>((ref) {
  final repository = ref.watch(censusRepositoryProvider);
  return CensusNotifier(repository);
});
