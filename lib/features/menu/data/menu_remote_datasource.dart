import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../models/menu_item_model.dart';

class MenuRemoteDataSource {
  MenuRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<MenuItemModel>> fetchItems() async {
    final response = await _client.get(
      Uri.parse('${AppConstants.apiBaseUrl}/products?limit=20&skip=0'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to load menu items');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> products =
        data['products'] as List<dynamic>? ?? <dynamic>[];

    final remoteItems = products
        .map(
          (dynamic item) =>
              MenuItemModel.fromJson(item as Map<String, dynamic>),
        )
        .where(_isCafeFriendlyItem)
        .map(_normalizeCategory)
        .toList();

    if (remoteItems.length >= 8) {
      return remoteItems;
    }

    return <MenuItemModel>[
      ...remoteItems,
      ..._fallbackMenu.where(
        (MenuItemModel fallback) => !remoteItems.any(
          (MenuItemModel item) =>
              item.title.toLowerCase() == fallback.title.toLowerCase(),
        ),
      ),
    ];
  }

  Future<MenuItemModel> addItem(MenuItemModel item) async {
    final response = await _client.post(
      Uri.parse('${AppConstants.apiBaseUrl}/products/add'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to add menu item');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return _normalizeCategory(MenuItemModel.fromJson(data)).copyWith(
      title: item.title,
      description: item.description,
      price: item.price,
      category: item.category,
      thumbnail: item.thumbnail,
      isAvailable: item.isAvailable,
      isSynced: true,
    );
  }

  Future<MenuItemModel> updateItem(MenuItemModel item) async {
    final targetId = item.id ?? 1;
    final response = await _client.put(
      Uri.parse('${AppConstants.apiBaseUrl}/products/$targetId'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to update menu item');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return _normalizeCategory(MenuItemModel.fromJson(data)).copyWith(
      id: item.id,
      title: item.title,
      description: item.description,
      price: item.price,
      category: item.category,
      thumbnail: item.thumbnail,
      isAvailable: item.isAvailable,
      isSynced: true,
    );
  }

  Future<void> deleteItem(int id) async {
    final response = await _client.delete(
      Uri.parse('${AppConstants.apiBaseUrl}/products/$id'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to delete menu item');
    }
  }

  MenuItemModel _normalizeCategory(MenuItemModel item) {
    final raw = item.category.toLowerCase();
    final title = item.title.toLowerCase();
    String category;

    if (_containsAny(title, <String>['coffee', 'tea', 'latte', 'espresso'])) {
      category = 'Hot Drinks';
    } else if (_containsAny(title, <String>['ice', 'juice', 'soda', 'cold'])) {
      category = 'Cold Drinks';
    } else if (_containsAny(title, <String>[
      'croissant',
      'bread',
      'muffin',
      'bagel',
      'bun',
      'roll',
    ])) {
      category = 'Pastries';
    } else if (_containsAny(title, <String>[
      'sandwich',
      'wrap',
      'toast',
      'panini',
    ])) {
      category = 'Sandwiches';
    } else if (_containsAny(title, <String>[
      'cake',
      'cookie',
      'brownie',
      'dessert',
      'ice cream',
      'chocolate',
    ])) {
      category = 'Desserts';
    } else if (raw.contains('groceries')) {
      if (_containsAny(title, <String>['drink', 'water', 'juice'])) {
        category = 'Cold Drinks';
      } else if (_containsAny(title, <String>[
        'snack',
        'chocolate',
        'cake',
        'cookie',
      ])) {
        category = 'Desserts';
      } else {
        category = 'Pastries';
      }
    } else {
      category = 'Hot Drinks';
    }

    return item.copyWith(category: category);
  }

  bool _isCafeFriendlyItem(MenuItemModel item) {
    final text = '${item.title} ${item.description} ${item.category}'
        .toLowerCase();

    if (_containsAny(text, _blockedKeywords)) {
      return false;
    }

    return _containsAny(text, _allowedKeywords);
  }

  bool _containsAny(String source, List<String> keywords) {
    return keywords.any(source.contains);
  }

  static const List<String> _blockedKeywords = <String>[
    'bed',
    'table',
    'chair',
    'sofa',
    'furniture',
    'perfume',
    'fragrance',
    'lipstick',
    'beauty',
    'chopsticks',
    'meat',
    'beef',
    'chicken',
    'knife',
    'tool',
  ];

  static const List<String> _allowedKeywords = <String>[
    'coffee',
    'espresso',
    'latte',
    'tea',
    'cappuccino',
    'mocha',
    'juice',
    'smoothie',
    'water',
    'soda',
    'drink',
    'croissant',
    'muffin',
    'bagel',
    'bread',
    'cake',
    'cookie',
    'brownie',
    'dessert',
    'ice cream',
    'chocolate',
    'sandwich',
    'toast',
    'panini',
    'pastry',
    'snack',
    'milk',
    'honey',
    'fruit',
    'egg',
    'groceries',
  ];

  static const List<MenuItemModel> _fallbackMenu = <MenuItemModel>[
    MenuItemModel(
      id: 1001,
      title: 'Cappuccino',
      description: 'Espresso with steamed milk and a soft foam finish.',
      price: 160,
      category: 'Hot Drinks',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1002,
      title: 'Iced Latte',
      description: 'Chilled espresso poured over milk and ice.',
      price: 170,
      category: 'Cold Drinks',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1003,
      title: 'Mocha',
      description: 'Rich espresso drink with chocolate and velvety milk.',
      price: 180,
      category: 'Hot Drinks',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1004,
      title: 'Blueberry Muffin',
      description: 'Freshly baked muffin with soft crumbs and berry filling.',
      price: 120,
      category: 'Pastries',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1005,
      title: 'Butter Croissant',
      description: 'Flaky breakfast pastry baked until golden and crisp.',
      price: 110,
      category: 'Pastries',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1006,
      title: 'Club Sandwich',
      description: 'Toasted sandwich stacked with crisp vegetables and sauce.',
      price: 220,
      category: 'Sandwiches',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1007,
      title: 'Chocolate Brownie',
      description: 'Dense chocolate brownie served as a sweet afternoon bite.',
      price: 130,
      category: 'Desserts',
      isAvailable: true,
      isSynced: true,
    ),
    MenuItemModel(
      id: 1008,
      title: 'Lemon Tea',
      description: 'Bright black tea with citrus and a little honey.',
      price: 140,
      category: 'Hot Drinks',
      isAvailable: true,
      isSynced: true,
    ),
  ];
}
