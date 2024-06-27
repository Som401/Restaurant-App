import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addOrder({
    required UserProvider userProvider,
    required String address,
    required String notes,
  }) async {
    if (userProvider.cart.isEmpty) {
      throw Exception("Cart is empty");
    }
    final String userId = _auth.currentUser?.uid ?? 'anonymous';

    Map<String, dynamic> order = {
      'userId': userId,
      'isDelivery': address.isNotEmpty,
      'address': address.isEmpty ? 'no_delivery' : address,
      'notes': notes,
      'items': userProvider.cart.map((cartItem) {
        return {
          'food': cartItem.food.name,
          'selectedAddons':
              cartItem.selectedAddons.map((addon) => addon.name).toList(),
          'quantity': cartItem.quantity,
          'price': cartItem.totalPrice,
        };
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
      'state': 'pending',
    };

    try {
      await _firestore.collection('orders').add(order);
      print("Order added: $order");
      userProvider.clearCart();
    } catch (e) {
      print("Failed to add order: $e");
      throw Exception("Failed to add order");
    }
  }

  Future<List<dynamic>> fetchUserOrders() async {
    final String userId = _auth.currentUser?.uid ?? 'anonymous';

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      List<dynamic> orders = [];
      for (var doc in querySnapshot.docs) {
        var order = doc.data();
        orders.add(order);
      }
      await Future.delayed(const Duration(seconds: 2));

      return orders;
    } catch (e) {
      print("Failed to fetch orders: $e");

      throw Exception("Failed to fetch orders: $e");
    }
  }
}
