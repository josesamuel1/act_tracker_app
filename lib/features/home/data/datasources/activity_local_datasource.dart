import 'package:act_tracker/core/database/tables/tables.dart';
import 'package:act_tracker/features/home/data/models/activity_entry.model.dart';
import 'package:sqflite/sqflite.dart';

abstract class ActivityLocalDatasource {
  Future<void> insertEntry({required ActivityEntryModel entry});
  Future<List<ActivityEntryModel>> getEntriesByDate({required int userId, required DateTime date});
  Future<List<ActivityEntryModel>> getEntriesByDateRange({
    required int userId,
    required DateTime start,
    required DateTime end,
  });
  Future<void> updateEntry({required ActivityEntryModel entry});
  Future<void> deleteEntry({required int entryId});
}

class ActivityLocalDatasourceImpl implements ActivityLocalDatasource {
  final Database _db;

  ActivityLocalDatasourceImpl(this._db);

  // Insert a new activity entry into the database
  @override
  Future<void> insertEntry({required ActivityEntryModel entry}) async {
    final entryJson = entry.toJson();

    await _db.insert(
      ActivityEntryTable.tableName,
      entryJson,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Get all activity entries for a given date
  @override
  Future<List<ActivityEntryModel>> getEntriesByDate({
    required int userId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final startOfDayString = startOfDay.toIso8601String();
    final endOfDayString = endOfDay.toIso8601String();

    // Query the database for all activity entries for the given date
    final result = await _db.query(
      ActivityEntryTable.tableName,
      where:
          '''
      ${ActivityEntryTable.userId} = ? AND
      ${ActivityEntryTable.startTime} >= ? AND
      ${ActivityEntryTable.startTime} < ?
      ''',
      whereArgs: [userId, startOfDayString, endOfDayString],
      orderBy: '${ActivityEntryTable.startTime} ASC',
    );

    return result.map((e) => ActivityEntryModel.fromJson(e)).toList();
  }

  // Get all activity entries for a given date range
  @override
  Future<List<ActivityEntryModel>> getEntriesByDateRange({
    required int userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final result = await _db.query(
      ActivityEntryTable.tableName,
      where:
          '''
      ${ActivityEntryTable.userId} = ? AND 
      ${ActivityEntryTable.startTime} >= ? AND 
      ${ActivityEntryTable.startTime} < ?
      ''',
      whereArgs: [userId, start.toIso8601String(), end.toIso8601String()],
    );

    return result.map((e) => ActivityEntryModel.fromJson(e)).toList();
  }

  // Update an existing activity entry in the database
  @override
  Future<void> updateEntry({required ActivityEntryModel entry}) async {
    final entryJson = entry.toJson();
    final entryId = entry.id;

    await _db.update(
      ActivityEntryTable.tableName,
      entryJson,
      where: '${ActivityEntryTable.id} = ?',
      whereArgs: [entryId],
    );
  }

  // Delete an activity entry from the database
  @override
  Future<void> deleteEntry({required int entryId}) async {
    await _db.delete(
      ActivityEntryTable.tableName,
      where: '${ActivityEntryTable.id} = ?',
      whereArgs: [entryId],
    );
  }
}
