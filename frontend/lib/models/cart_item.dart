class FoodInfo {
  final String id;
  final String name;
  final double price;
  final String imagePath;

  FoodInfo(
      {required this.name, required this.price, required this.imagePath,required this.id,});
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
}
