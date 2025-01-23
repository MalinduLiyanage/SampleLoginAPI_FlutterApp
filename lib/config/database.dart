import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late Database database;

  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app_data.db');

    database = await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE UserData (
            User_Code TEXT PRIMARY KEY,
            User_Display_Name TEXT,
            Email TEXT,
            User_Employee_Code TEXT,
            Company_Code TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE UserLocations (
            Location_Id INTEGER PRIMARY KEY AUTOINCREMENT,
            User_Code TEXT,
            Location_Code TEXT,
            UNIQUE(User_Code, Location_Code),
            FOREIGN KEY (User_Code) REFERENCES UserData (User_Code) ON DELETE CASCADE
          )
        ''');
        db.execute('''
          CREATE TABLE UserPermissions (
            Permission_Id INTEGER PRIMARY KEY AUTOINCREMENT,
            User_Code TEXT,
            Permission_Name TEXT,
            Permission_Status TEXT,
            UNIQUE(User_Code, Permission_Name),
            FOREIGN KEY (User_Code) REFERENCES UserData (User_Code) ON DELETE CASCADE
          )
        ''');
      },
      version: 1,
    );
  }

  Future<Database> getDatabase() async {
    if (database == null) {
      await initDatabase();
    }
    return database;
  }
}
