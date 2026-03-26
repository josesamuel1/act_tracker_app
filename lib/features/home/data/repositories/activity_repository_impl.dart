import 'package:act_tracker/features/home/data/data.dart';
import 'package:act_tracker/features/home/domain/domain.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDatasource local;

  ActivityRepositoryImpl({required this.local});

  @override
  Future<void> insertEntry({required ActivityEntryEntity entry}) async {
    final entryModel = ActivityEntryModel(
      id: entry.id,
      userId: entry.userId,
      title: entry.title,
      description: entry.description,
      startTime: entry.startTime,
      endTime: entry.endTime,
    );

    final result = await local.insertEntry(entry: entryModel);

    return result;
  }

  @override
  Future<List<ActivityEntryEntity>> getEntriesByDate({
    required int userId,
    required DateTime date,
  }) async {
    final entries = await local.getEntriesByDate(userId: userId, date: date);

    return entries;
  }

  @override
  Future<List<ActivityEntryEntity>> getEntriesByDateRange({
    required int userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final entries = await local.getEntriesByDateRange(userId: userId, start: start, end: end);

    return entries;
  }

  @override
  Future<void> updateEntry({required ActivityEntryEntity entry}) async {
    final entryModel = ActivityEntryModel(
      id: entry.id,
      userId: entry.userId,
      title: entry.title,
      description: entry.description,
      startTime: entry.startTime,
      endTime: entry.endTime,
    );

    final result = await local.updateEntry(entry: entryModel);

    return result;
  }

  @override
  Future<void> deleteEntry({required int entryId}) async {
    final result = await local.deleteEntry(entryId: entryId);

    return result;
  }
}
