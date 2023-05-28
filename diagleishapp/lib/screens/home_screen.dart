import 'package:flutter/material.dart';
import 'package:diagleishapp/widgets/analyze_widget.dart';
import 'package:diagleishapp/widgets/home_widget.dart';
import 'package:diagleishapp/widgets/setting_widget.dart';
import 'package:diagleishapp/models/authentication.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.auth,
    required this.onSignedOut,
  }) : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeWidget(),
    const AnalyzeWidget(),
    const SettingWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text("Diagleish"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.biotech,
              size: 24,
            ),
            label: 'Análise',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              size: 24,
            ),
            label: 'Informativos',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
