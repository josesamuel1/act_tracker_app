class UserTable {
  // Table name
  static const String tableName = 'users';

  // Column names
  static const String id = 'id';
  static const String username = 'username';
  static const String passwordHash = 'password_hash';

  // SQL statement to create the table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $username TEXT NOT NULL UNIQUE,
      $passwordHash TEXT NOT NULL
    )''';
}
