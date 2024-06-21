class FoodInfo {
  final String name;
  final double price;
  final String imagePath;

  FoodInfo({required this.name, required this.price, required this.imagePath});
}

class AddonInfo {
  final String name;
  final double price;

  AddonInfo({required this.name, required this.price});
}

class CartItem {
  FoodInfo food;
  List<AddonInfo> selectedAddons;
  int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
  });

  double get totalPrice {
    double total = food.price;
    for (AddonInfo addon in selectedAddons) {
      total += addon.price;
    }
    return total * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'food': {
        'name': food.name,
      },
      'selectedAddons': selectedAddons
          .map((addon) => {
                'name': addon.name,
              })
          .toList(),
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
