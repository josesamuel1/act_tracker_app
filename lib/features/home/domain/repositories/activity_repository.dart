import 'package:act_tracker/features/home/domain/entities/activity_entry.entity.dart';

abstract class ActivityRepository {
  Future<void> insertEntry({required ActivityEntryEntity entry});
  Future<List<ActivityEntryEntity>> getEntriesByDate({required int userId, required DateTime date});
  Future<List<ActivityEntryEntity>> getEntriesByDateRange({
    required int userId,
    required DateTime start,
    required DateTime end,
  });
  Future<void> updateEntry({required ActivityEntryEntity entry});
  Future<void> deleteEntry({required int entryId});
}
