class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int price; // whole dinars
  final String categoryId;

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? price,
    String? categoryId,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FoodItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
