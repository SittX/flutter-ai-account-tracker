import "package:ai_tracker/features/account_tracking/data/models/account_model.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase _instance = AppDatabase._internal();

  static Database? _database;

  factory AppDatabase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "app_internal.db");

    return await (openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            $idField $idType,
            $nameField $textType,
            $descriptionField $textType,
            $emailField $textTypeUnique,
            $statusField $textType,
            $isActiveField $intTypeNotNullDefaultZero,             
            $lastUsedDateField $textType,
            $nextAvailableDateField $textType,
            $createdDateTimeField $textType,
            $updatedDateTimeField $textType
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $nextAvailableDateField $textType',
          );
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $createdDateTimeField $textType',
          );
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $updatedDateTimeField $textType',
          );
        }
      },
    ));
  }
}
