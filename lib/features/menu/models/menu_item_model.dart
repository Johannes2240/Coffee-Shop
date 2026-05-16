class MenuItemModel {
  const MenuItemModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.thumbnail,
    this.isAvailable = true,
    this.isSynced = false,
  });

  final int? id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String? thumbnail;
  final bool isAvailable;
  final bool isSynced;

  MenuItemModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? thumbnail,
    bool? isAvailable,
    bool? isSynced,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      isAvailable: isAvailable ?? this.isAvailable,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int?,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] ?? 'Hot Drinks') as String,
      thumbnail: json['thumbnail'] as String?,
      isAvailable: (json['stock'] as int?) != 0,
      isSynced: true,
    );
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      category: map['category'] as String? ?? 'Hot Drinks',
      thumbnail: map['thumbnail'] as String?,
      isAvailable: (map['is_available'] as int? ?? 1) == 1,
      isSynced: (map['is_synced'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'thumbnail': thumbnail,
      'stock': isAvailable ? 1 : 0,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'thumbnail': thumbnail,
      'is_available': isAvailable ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
    };
  }
}
