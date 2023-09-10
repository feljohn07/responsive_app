import 'package:flutter/material.dart';
import 'package:responsive_app/event_list/views/event_view.dart';
import 'package:responsive_app/pos.dart';
import 'package:responsive_app/responsive_table.dart';
import 'package:responsive_app/users_list/views/home_screen.dart';

List<Map<String, dynamic>> routes = [
  {
    'title': Text('Home'),
    'icon': Icon(Icons.home),
    'widget': PointOfSaleScreen()
  },
  {
    'title': Text('Table'),
    'icon': Icon(Icons.table_chart),
    'widget': DataPage()
  },
  {
    'title': Text('MVVM tutorial'),
    'icon': Icon(Icons.data_object),
    'widget': HomeScreen()
  },
  {
    'title': Text('Event Manager'),
    'icon': Icon(Icons.data_object),
    'widget': EventView()
  },
];
