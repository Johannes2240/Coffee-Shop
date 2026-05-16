import 'package:sqflite/sqflite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/db/database_helper.dart';
import '../models/menu_item_model.dart';

class MenuLocalDataSource {
  Future<List<MenuItemModel>> fetchItems() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      AppConstants.menuTable,
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(MenuItemModel.fromMap).toList();
  }

  Future<MenuItemModel> upsertItem(MenuItemModel item) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      AppConstants.menuTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return item.copyWith(id: item.id ?? id);
  }

  Future<void> cacheItems(List<MenuItemModel> items) async {
    final db = await DatabaseHelper.instance.database;
    final batch = db.batch();

    batch.delete(
      AppConstants.menuTable,
      where: 'is_synced = ?',
      whereArgs: <Object>[1],
    );

    for (final item in items) {
      batch.insert(
        AppConstants.menuTable,
        item.copyWith(isSynced: true).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      AppConstants.menuTable,
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }
}
