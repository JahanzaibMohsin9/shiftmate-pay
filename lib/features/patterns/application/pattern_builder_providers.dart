import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/entities.dart';

final shiftPatternsForJobProvider =
    FutureProvider.family<List<ShiftPattern>, String>((ref, jobId) async {
  final result = await ref.watch(shiftPatternRepositoryProvider).listPatternsForJob(jobId);
  return result.when(
    success: (patterns) => patterns,
    failure: (error) => throw error,
  );
});

final activeShiftPatternForJobProvider =
    FutureProvider.family<ShiftPattern?, String>((ref, jobId) async {
  final result = await ref.watch(shiftPatternRepositoryProvider).getActivePatternForJob(jobId);
  return result.when(
    success: (pattern) => pattern,
    failure: (error) => throw error,
  );
});

final shiftPatternEntriesProvider =
    FutureProvider.family<List<ShiftPatternEntry>, String>((ref, patternId) async {
  final result = await ref.watch(shiftPatternEntryRepositoryProvider).listEntriesForPattern(patternId);
  return result.when(
    success: (entries) => entries,
    failure: (error) => throw error,
  );
});
