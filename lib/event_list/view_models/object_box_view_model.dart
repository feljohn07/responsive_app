import 'package:flutter/material.dart';
import '../repo/objectbox.dart';

late ObjectBox objectbox;

class ObjectBoxViewModel extends ChangeNotifier {
  initObjectBox() async {
    objectbox = await ObjectBox.create();
  }

  loadData() async {
    objectbox.putDemoData();
  }

  deleteAll() {
    objectbox.remodeAll();
  }
}
