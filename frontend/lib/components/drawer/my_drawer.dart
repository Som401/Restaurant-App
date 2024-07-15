import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/drawer/my_drawer_tile.dart';
import 'package:frontend/pages/menu_page.dart';
import 'package:frontend/pages/orders_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/table_reservation_page.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final bool isLoadingCategories;
  final bool isLoadingMenu;
  final bool isLoadingUser;
  const MyDrawer(
      {super.key,
      this.isLoadingCategories = false,
      this.isLoadingMenu = false,
      this.isLoadingUser = false});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    final UserService userService = UserService();

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    String logoPath = isDarkMode
        ? "assets/images/delcapo_logo.png"
        : "assets/images/light_mode_delcapo_logo.png";

    return Drawer(
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.surface,
      width: width * 0.8,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Image.asset(
                  logoPath,
                  width: minDimension * 0.4,
                  height: minDimension * 0.6,
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                MyDrawerTile(
                  text: "M E N U",
                  icon: Icons.restaurant_menu,
                  onTap: () {
                    if (isLoadingCategories || isLoadingMenu) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please wait until data is loaded.',
                            style: TextStyle(fontSize: minDimension * 0.04),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MenuPage()),
                          (Route route) => false);
                    }
                  },
                ),
                MyDrawerTile(
                  text: "T A B L E\nR E S E R V A T I O N",
                  icon: Icons.table_restaurant,
                  onTap: () {
                    if (isLoadingCategories || isLoadingMenu) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please wait until data is loaded.',
                            style: TextStyle(fontSize: minDimension * 0.04),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TableReservationPage()),
                          (Route route) => false);
                    }
                  },
                ),
                MyDrawerTile(
                  text: "O R D E R S",
                  icon: Icons.list_alt,
                  onTap: () {
                    if (isLoadingCategories || isLoadingMenu) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please wait until data is loaded.',
                            style: TextStyle(fontSize: minDimension * 0.04),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const OrdersPage()),
                          (Route route) => false);
                    }
                  },
                ),
                MyDrawerTile(
                  text: "P R O F I L E",
                  icon: Icons.person,
                  onTap: () {
                    if (isLoadingCategories || isLoadingMenu) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please wait until data is loaded.',
                            style: TextStyle(fontSize: minDimension * 0.04),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                          (Route route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              MyDrawerTile(
                text: "L O G O U T",
                icon: Icons.exit_to_app,
                onTap: () {
                  userService.signOut(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                      (Route route) => false);
              
                },
              ),
              SizedBox(height: height*0.02,)
            ],
          ),

        ],
      ),
    );
  }
}
