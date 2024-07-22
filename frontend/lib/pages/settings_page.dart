import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/pages/cart_page.dart';
import 'package:frontend/pages/change_password_page.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class SettignsPage extends StatelessWidget {
  SettignsPage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final UserService userService = UserService();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: "Your Orders",
        scaffoldKey: _scaffoldKey,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personel Information',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                    SizedBox(height: height * 0.01),
                    GestureDetector(
                      onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );},
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: minDimension * 0.07),
                                SizedBox(width: width * 0.02),
                                Text('My Profile',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        fontSize: minDimension * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: minDimension * 0.04),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: minDimension * 0.07),
                                SizedBox(width: width * 0.02),
                                Text('My Cart',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: minDimension * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: minDimension * 0.04),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text('Security',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                    SizedBox(height: height * 0.01),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_reset_outlined,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: minDimension * 0.07),
                                SizedBox(width: width * 0.02),
                                Text('Change Password',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        fontSize: minDimension * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: minDimension * 0.04),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.password_outlined,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: minDimension * 0.07),
                                SizedBox(width: width * 0.02),
                                Text('Forgot Password',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        fontSize: minDimension * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: minDimension * 0.04),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text('General',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                    SizedBox(height: height * 0.01),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.language_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: minDimension * 0.07),
                              SizedBox(width: width * 0.02),
                              Text('Language',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: minDimension * 0.04,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary,
                              size: minDimension * 0.04),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dark_mode_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: minDimension * 0.07,
                            ),
                            SizedBox(width: width * 0.02),
                            Text("Dark Mode",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: minDimension * 0.04,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        CupertinoSwitch(
                          value:
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .isDarkMode,
                          onChanged: (value) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                          activeColor:
                              Theme.of(context).colorScheme.inverseSurface,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: MyButton(
                text: 'Log Out',
                onTap: () {
                  userService.signOut(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                      (Route route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
