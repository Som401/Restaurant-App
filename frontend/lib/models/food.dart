class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String category;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      price: json['price'],
      category: json['category'],
      availableAddons: (json['availableAddons'] as List)
          .map((i) => Addon.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'category': category,
      'availableAddons':
          availableAddons.map((addon) => addon.toJson()).toList(),
    };
  }
}

class Addon {
  String name;
  double price;

  Addon({required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
