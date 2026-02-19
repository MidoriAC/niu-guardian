import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../features/census/infrastructure/models/parent_model.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [
        ParentModelSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
  }

  return Isar.getInstance()!;
});
