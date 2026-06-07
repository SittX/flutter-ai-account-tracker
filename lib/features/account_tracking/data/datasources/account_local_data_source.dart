import 'package:ai_tracker/core/database/app_database.dart';
import 'package:ai_tracker/features/account_tracking/data/models/account_model.dart';

import '../../../../core/constants/account_status.dart';

class AccountLocalDataSource {
  AccountLocalDataSource();

  Future<List<AccountModel>> fetchAll() async {
    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((acc) => AccountModel.fromJson(acc)).toList();
  }

  Future<AccountModel> fetchById(int id) async {
    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "$idField = ?",
      whereArgs: [id],
      limit: 1,
    );

    return AccountModel.fromJson(maps[0]);
  }

  Future<AccountModel> createNewAccount(AccountModel data) async {
    final db = await AppDatabase().database;
    int assignedId = await db.insert(tableName, data.toJson());

    return data.copyWith(id: assignedId);
  }

  Future<AccountModel> updateExistingAccount(int id, AccountModel data) async {
    if (id <= 0) throw Exception("Id parameter value cannot be zero");

    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> existingData = await db.query(
      tableName,
      where: "$idField = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (existingData.isEmpty) {
      throw Exception("Existing account with ID:$id does not exist");
    }

    final Map<String, dynamic> updatePayload = data.toJson();

    await db.update(
      tableName,
      updatePayload,
      where: "$idField = ? ",
      whereArgs: [id],
    );

    return data.id == null ? data.copyWith(id: id) : data;
  }

  Future<int> updateAccountStatus(int id, AccountStatus status) async {
    if (id <= 0) throw Exception("Account ID cannot be <= zero : $id");

    final db = await AppDatabase().database;

    final affectedRows = await db.update(
      tableName,
      {
        statusField: status.name,
        updatedDateTimeField: DateTime.now().toIso8601String(),
      },
      where: "$idField = ?",
      whereArgs: [id],
    );

    return affectedRows;
  }

  Future<int> deleteAccount(int id) async {
    if (id <= 0) throw Exception("Delete Account ID cannot be <= zero: $id");

    final db = await AppDatabase().database;

    final affectedRows = await db.delete(
      tableName,
      where: "$idField = ?",
      whereArgs: [id],
    );

    return affectedRows;
  }
}
