import 'package:flutter/material.dart';
import '../widgets/tm_app_bar.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_screen.dart';
import 'progress_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,

          onDestinationSelected: (index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: const [
        NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
        NavigationDestination(icon: Icon(Icons.ac_unit_sharp), label: 'Progress'),
        NavigationDestination(icon: Icon(Icons.incomplete_circle), label: 'Completed'),
        NavigationDestination(icon: Icon(Icons.cancel), label: 'Canceled'),
      ]),
    );
  }
}
