import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/features/menu/models/menu_item_model.dart';

void main() {
  test('menu item copyWith keeps existing values when fields are omitted', () {
    const item = MenuItemModel(
      id: 1,
      title: 'House Latte',
      description: 'Espresso with steamed milk',
      price: 4.5,
      category: 'Hot Drinks',
      isAvailable: true,
      isSynced: false,
    );

    final updated = item.copyWith(price: 5.0, isSynced: true);

    expect(updated.title, 'House Latte');
    expect(updated.price, 5.0);
    expect(updated.isSynced, isTrue);
    expect(updated.isAvailable, isTrue);
  });
}
