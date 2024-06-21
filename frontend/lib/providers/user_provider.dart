import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/cart_item.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void addToCart(FoodInfo food, List<AddonInfo> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food.name == food.name;
      bool isSameAddons = const ListEquality().equals(
        item.selectedAddons.map((addon) => addon.name).toList(),
        selectedAddons.map((addon) => addon.name).toList(),
      );
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(
        food: food,
        selectedAddons: selectedAddons,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (_cart[cartIndex].quantity > 1) {
      _cart[cartIndex].quantity--;
    } else {
      _cart.removeAt(cartIndex);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (AddonInfo addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  String displaycartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("- - - - - - - - - -");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt
            .writeln("   Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }
    receipt.writeln("- - - - - - - - - -");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  String _formatAddons(List<AddonInfo> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
