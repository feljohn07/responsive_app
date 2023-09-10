import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (_selectedIndex) {
      case 0:
        page = const MyHomepage();
        break;
      case 1:
        page = MyText(selectedIndex: _selectedIndex);
        break;

      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          
        ),
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              destinations: List.generate(
                  2,
                  (index) => NavigationRailDestination(
                      icon: Icon(Icons.abc), label: Text('Destion $index'))),
              selectedIndex: 0,
              onDestinationSelected: (value) => (int value) {
                setState(() {
                  _selectedIndex = value;
                });
              }(value),
            ),
            Expanded(
              child: page,
            ),
          ],
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required int selectedIndex,
  }) : _selectedIndex = selectedIndex;

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hello World! $_selectedIndex'),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
