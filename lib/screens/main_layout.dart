import 'package:flutter/material.dart';
import 'package:daleel/screens/home_screen.dart';
import 'package:daleel/screens/saved_screen.dart';
import 'package:daleel/screens/settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; 
  
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SavedScreen(),
    SettingsScreen(),
  ];

  
  static const List<String> _appBarTitles = <String>[
    'الرئيسية', 
    'مفضلتي', 
    'المزيد', 
  ];

  
  static const List<IconData> _appBarIcons = <IconData>[
    Icons.home, 
    Icons.bookmark, 
    Icons.more_horiz, 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        
        title: Row(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            
             Baseline(
               baseline: 18.0, 
               baselineType: TextBaseline.alphabetic,
               child: Icon(_appBarIcons[_selectedIndex], size: 22) 
             ),
             const SizedBox(width: 8),
             Text(_appBarTitles[_selectedIndex]), 
          ],
        ),
        toolbarHeight: kToolbarHeight, 
        centerTitle: true, 
        
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'مفضلتي', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined), 
            activeIcon: Icon(Icons.more_horiz), 
            label: 'المزيد', 
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.primaryColor, 
        unselectedItemColor: theme.colorScheme.secondary, 
        onTap: _onItemTapped,
        showUnselectedLabels: true, 
        type: BottomNavigationBarType.fixed, 
      ),
    );
  }
} 