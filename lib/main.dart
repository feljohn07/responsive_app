import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/event_list/view_models/object_box_view_model.dart';
import 'package:responsive_app/event_list/view_models/events_view_model.dart';
import 'package:responsive_app/owner_list/view_models/owner_view_model.dart';
import 'package:responsive_app/task_list/view_models/task_view_model.dart';
import 'package:responsive_app/users_list/view_models/users_view_model.dart';
import 'package:responsive_app/utils/window_manager.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox
  ObjectBoxViewModel _ = ObjectBoxViewModel();
  _.initObjectBox();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  bool _isExtended = false;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
  }

  hideTitleBar() {
    setState(() {
      _isHidden = !_isHidden;
    });
    windowFullScreen(_isHidden);
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    try {
      page = routes[_selectedIndex]['widget'];
    } on Exception catch (e) {
      throw UnimplementedError('no widget for $_selectedIndex: $e');
    }

    if (MediaQuery.of(context).size.width > 800) {
      setState(() {
        _isExtended = true;
      });
    } else {
      setState(() {
        _isExtended = false;
      });
    }

    Widget navigationRail() {
      return NavigationRail(
        extended: _isExtended,
        elevation: 8.0,
        destinations: routes
            .map(
              (route) => NavigationRailDestination(
                icon: route['icon'],
                label: route['title'],
              ),
            )
            .toList(),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) => (int value) {
          setState(() {
            _selectedIndex = value;
          });
        }(value),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        ChangeNotifierProvider(create: (_) => ObjectBoxViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => OwnerViewModel()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 400) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                appBar: AppBar(title: Text('Point of sale'), actions: [
                  InkWell(
                    onTap: () => hideTitleBar(),
                    child: Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: _isHidden
                            ? Icon(Icons.fullscreen_exit)
                            : Icon(Icons.fullscreen)),
                  )
                ]),
                body: Row(
                  children: [
                    (MediaQuery.of(context).size.width <= 400)
                        ? Container()
                        : navigationRail(),
                    Expanded(
                      child: page,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                drawer: SafeArea(
                  child: Builder(builder: (context) {
                    return Drawer(
                        child: ListView(
                            padding: EdgeInsets.zero,
                            children: routes
                                .asMap()
                                .entries
                                .map(
                                  (e) => ListTile(
                                    leading: e.value['icon'],
                                    title: e.value['title'],
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = e.key;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                                .toList()));
                  }),
                ),
                appBar: AppBar(
                  title: Text('Point of sale'),
                  leading: Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  }),
                ),
                body: Row(
                  children: [
                    Expanded(
                      child: page,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
