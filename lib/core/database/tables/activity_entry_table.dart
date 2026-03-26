import 'package:act_tracker/core/database/tables/user_table.dart';

class ActivityEntryTable {
  // Table name
  static const String tableName = 'activity_entry';

  // Column names
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String startTime = 'start_time';
  static const String endTime = 'end_time';

  // SQL statement to create the table
  static const String createTable =
      '''
  CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $userId INTEGER NOT NULL,
    $title TEXT NOT NULL,
    $description TEXT,
    $startTime TEXT NOT NULL,
    $endTime TEXT NOT NULL,
    FOREIGN KEY ($userId) REFERENCES ${UserTable.tableName}(${UserTable.id}) ON DELETE CASCADE
  )''';
}
