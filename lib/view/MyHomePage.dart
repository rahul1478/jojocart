import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:jojocart_mobile/view/CategoriesScreen.dart';
import 'package:jojocart_mobile/view/MouthWateringCakesPage.dart';
import 'package:jojocart_mobile/view/OccasionsScreen.dart';
import 'package:jojocart_mobile/view/SameDayPage.dart';

import '../theme/appTheme.dart';
import 'AccountPage.dart';
import 'HomePage.dart';
import 'LoginScreen.dart';
// Import your page files here


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _location = "New York";
  String _pincode = "10001";

  // List of pages to be displayed
  final List<Widget> _pages = [
    HomePage(),
    SameDayPage(searchText: "same day"),
    CategoriesScreen(),
    OccasionsScreen(),
    const AccountPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(Icons.location_on_outlined),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_location, style: context.titleMedium),
            Text(_pincode, style: context.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout_outlined),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          color: Colors.blueGrey,
          buttonBackgroundColor: Colors.blueGrey,
          height: 60,
          index: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_outlined, color: Colors.white, size: 22),
                SizedBox(height: 4),
                Text('Home', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Colors.white, size: 22),
                SizedBox(height: 4),
                Text('Same Day', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, color: Colors.white, size: 22),
                SizedBox(height: 4),
                Text('Category', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wine_bar_outlined, color: Colors.white, size: 22),
                SizedBox(height: 4),
                Text('Occasions', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, color: Colors.white, size: 22),
                SizedBox(height: 4),
                Text('Account', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Create the individual page widgets



class AllGiftsPage extends StatelessWidget {
  const AllGiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, size: 80, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text('All Gifts', style: context.headingSmall),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Browse through our extensive collection of gifts for all occasions!',
              style: context.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

