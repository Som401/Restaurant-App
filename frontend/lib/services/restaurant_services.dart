import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/cart_item.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addReservation({
    required String name,
    required String email,
    required String occasion,
    required DateTime selectedDay,
    required String phoneNumber, 
    required String dialCode, 
    required int nbGuests,
  }) async {
    try {
      Timestamp timestamp = Timestamp.fromDate(selectedDay);
      Map<String, dynamic> reservationData = {
        'userUid': _auth.currentUser?.uid ?? 'anonymous',
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'dialCode': dialCode,
        'selectedDay': timestamp,
        'nbGuests': nbGuests,
        'occasion': occasion,
      };

      await _firestore.collection('reservations').add(reservationData);
    } catch (e) {
      print("Failed to add reservation: $e");
      throw Exception("Failed to add reservation");
    }
  }

  Future<void> addOrder({
    required UserProvider userProvider,
    required String address,
    required String notes,
  }) async {
    if (userProvider.cart.isEmpty) {
      throw Exception("Cart is empty");
    }
    final String userId = _auth.currentUser?.uid ?? 'anonymous';

    final menu = await fetchMenu();

    List<Map<String, dynamic>> items =
        userProvider.cart.map((CartItem cartItem) {
      Food foodItem =
          menu.firstWhere((Food food) => food.id == cartItem.food.id);

      List<dynamic> allAddons = foodItem.availableAddons.map((addon) {
        return addon;
      }).toList();
      print(allAddons);
      List<bool> addonsSelection = allAddons
          .map((addon) => cartItem.selectedAddons
              .any((selectedAddon) => selectedAddon.name == addon.name))
          .toList();
      print(addonsSelection);
      return {
        'foodId': cartItem.food.id,
        'quantity': cartItem.quantity,
        'selectedAddons': addonsSelection,
      };
    }).toList();

    Map<String, dynamic> order = {
      'userId': userId,
      'isDelivery': address.isNotEmpty,
      'address': address.isEmpty ? 'no_delivery' : address,
      'notes': notes,
      'items': items,
      'timestamp': FieldValue.serverTimestamp(),
      'state': 'pending',
    };

    try {
      await _firestore.collection('orders').add(order);
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

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      List<String> categories = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var docCategories =
            List<String>.from(data['categories'] as List<dynamic>);

        categories.addAll(docCategories);
      }
      await Future.delayed(const Duration(seconds: 2));
      return categories.toList();
    } catch (e) {
      print("Failed to fetch categories: $e");
      throw Exception("Failed to fetch categories: $e");
    }
  }

  Future<List<Food>> fetchMenu() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      List<Food> menu = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var docMenu =
            List<Map<String, dynamic>>.from(data['menu'] as List<dynamic>);

        var foodItems = docMenu.map((item) => Food.fromJson(item)).toList();
        menu.addAll(foodItems);
      }
      await Future.delayed(const Duration(seconds: 2));
      return menu;
    } catch (e) {
      print("Failed to fetch menu: $e");
      throw Exception("Failed to fetch menu: $e");
    }
  }

  Future<Map<String, dynamic>> fetchRestaurantDetails() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var data = doc.data() as Map<String, dynamic>;
        String name = data['name'];
        String address = data['address'];
        int phoneNumber = data['phoneNumber'];
        double deliveryFee = (data['deliveryFee'] as num).toDouble();

        return {
          'name': name,
          'address': address,
          'phone': phoneNumber,
          'deliveryFee': deliveryFee,
        };
      } else {
        print('No restaurant details found');
        return {};
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      return {};
    }
  }
}
