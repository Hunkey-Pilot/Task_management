import 'package:flutter/material.dart';
import 'package:task_management/ui/screen/cancel_Task_screen.dart';
import 'package:task_management/ui/screen/completed_task_screen.dart';
import 'package:task_management/ui/screen/new_task_screen.dart';
import 'package:task_management/ui/screen/progress_task_screen.dart';

import '../widget/tm_app_bar.dart';


class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _screen= [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index){
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const[
          NavigationDestination(icon: Icon(Icons.new_label), label: "New Task"),
          NavigationDestination(icon: Icon(Icons.done), label: "Completed"),
          NavigationDestination(icon: Icon(Icons.cancel_outlined), label: "Canceled"),
          NavigationDestination(icon: Icon(Icons.ac_unit), label: "Progress"),
        ],
      ),
    );
  }
}


