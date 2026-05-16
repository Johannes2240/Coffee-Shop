import '../data/menu_local_datasource.dart';
import '../data/menu_remote_datasource.dart';
import '../models/menu_item_model.dart';

class MenuRepository {
  const MenuRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;

  Future<List<MenuItemModel>> fetchItems() async {
    try {
      final items = await remoteDataSource.fetchItems();
      await localDataSource.cacheItems(items);
    } catch (_) {
      // Local fallback keeps the manager view available offline.
    }

    return localDataSource.fetchItems();
  }

  Future<MenuItemModel> addItem(MenuItemModel item) async {
    try {
      final remoteItem = await remoteDataSource.addItem(item);
      return localDataSource.upsertItem(remoteItem.copyWith(isSynced: true));
    } catch (_) {
      return localDataSource.upsertItem(item.copyWith(isSynced: false));
    }
  }

  Future<MenuItemModel> updateItem(MenuItemModel item) async {
    try {
      final remoteItem = await remoteDataSource.updateItem(item);
      return localDataSource.upsertItem(
        remoteItem.copyWith(id: item.id, isSynced: true),
      );
    } catch (_) {
      return localDataSource.upsertItem(item.copyWith(isSynced: false));
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await remoteDataSource.deleteItem(id);
    } catch (_) {
      // Deleting locally still honors the user action when the API is unavailable.
    }

    await localDataSource.deleteItem(id);
  }
}
