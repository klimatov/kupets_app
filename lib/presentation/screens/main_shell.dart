import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/kupets_app_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indexFromLocation(String location) {
    if (location.startsWith('/promotions')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        context.go('/menu');
      case 1:
        context.go('/promotions');
      case 2:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);

    return Scaffold(
      appBar: const KupetsAppBar(),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Меню'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Акции'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
