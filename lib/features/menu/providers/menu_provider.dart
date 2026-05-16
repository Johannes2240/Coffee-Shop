import 'package:flutter/material.dart';

import '../models/menu_item_model.dart';
import '../repository/menu_repository.dart';

class MenuProvider extends ChangeNotifier {
  MenuProvider({required this.repository});

  final MenuRepository repository;

  List<MenuItemModel> items = <MenuItemModel>[];
  bool isLoading = false;
  String? error;
  String searchQuery = '';
  String selectedCategory = 'All';

  List<MenuItemModel> get filteredItems {
    return items.where((MenuItemModel item) {
      final matchesSearch =
          item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  int get availableCount =>
      items.where((MenuItemModel item) => item.isAvailable).length;

  int get unavailableCount =>
      items.where((MenuItemModel item) => !item.isAvailable).length;

  double get estimatedRevenue =>
      items.fold<double>(0, (double total, MenuItemModel item) {
        if (!item.isAvailable) {
          return total;
        }
        return total + item.price;
      });

  Future<void> fetchItems() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await repository.fetchItems();
    } catch (_) {
      error = 'Unable to load the menu right now.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(MenuItemModel item) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final created = await repository.addItem(item);
      items = <MenuItemModel>[
        created,
        ...items.where((MenuItemModel current) => current.id != created.id),
      ];
    } catch (_) {
      error = 'Unable to add this menu item.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateItem(MenuItemModel item) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updated = await repository.updateItem(item);
      items = items
          .map(
            (MenuItemModel current) =>
                current.id == updated.id ? updated : current,
          )
          .toList();
    } catch (_) {
      error = 'Unable to update this menu item.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteItem(id);
      items = items.where((MenuItemModel item) => item.id != id).toList();
    } catch (_) {
      error = 'Unable to remove this menu item.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }
}
