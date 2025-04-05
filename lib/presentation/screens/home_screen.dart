import 'package:authenticator_app/presentation/screens/info_screen.dart';
import 'package:authenticator_app/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/island_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // Define the list of screens/pages to navigate between
  final List<Widget> _pages = [
    MainScreen(), // Replace with your actual MainScreen
    InfoScreen(), // Replace with your actual InfoScreen
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
        title: const Text('Authenticator'),
        titleTextStyle: Theme.of(context).textTheme.displaySmall,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 38),
        child: IslandNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      extendBody: true,
    );
  }
}