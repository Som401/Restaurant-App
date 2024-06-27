import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/drawer/my_drawer_tile.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/orders_page.dart';
import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    final UserService _userService = UserService();

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    String logoPath = isDarkMode
        ? "assets/images/delcapo_logo.png"
        : "assets/images/light_mode_delcapo_logo.png";

    return Drawer(
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  text: "H O M E",
                  icon: Icons.home,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route route) => false);
                  },
                ),
                MyDrawerTile(
                  text: "T A B L E\nR E S E R V A T I O N",
                  icon: Icons.table_restaurant,
                  onTap: () {},
                ),
                MyDrawerTile(
                  text: "C A R T",
                  icon: Icons.shopping_cart,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const OrdersPage()),
                        (Route route) => false);
                  },
                ),
                MyDrawerTile(
                  //key: settingsTileKey,
                  text: "S E T T I N G S",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                        (Route route) => false);
                  },
                ),
              ],
            ),
          ),
          MyDrawerTile(
            text: "L O G O U T",
            icon: Icons.exit_to_app,
            onTap: () {
              _userService.signOut(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (Route route) => false);
            },
          ),
        ],
      ),
    );
  }
}
