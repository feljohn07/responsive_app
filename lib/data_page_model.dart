import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class DataPageModel {
  late List<DatatableHeader> headers;

  bool showID = true;

  List<int> perPages = [10, 20, 50, 100, 1000];
  int total = 100;
  int? currentPerPage = 10;
  List<bool>? expanded;
  String? searchKey = "id";

  int currentPage = 1;
  bool isSearch = false;
  List<Map<String, dynamic>> sourceOriginal = [];
  List<Map<String, dynamic>> sourceFiltered = [];
  List<Map<String, dynamic>> source = [];
  List<Map<String, dynamic>> selecteds = [];
  String selectableKey = "id";

  String? sortColumn;
  bool sortAscending = true;
  bool isLoading = true;
  bool showSelect = true;
  var random = Random();

  List<Map<String, dynamic>> generateData({int n = 10000}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = [];
    var i = 1;
    print(i);
    print(source.length);

    for (var data in source) {
      temps.add({
        "id": i,
        "sku": "$i\000$i",
        "name": "Product $i",
        "category": "Category-$i",
        "price": i * 10.00,
        "cost": "20.00",
        "margin": "${i}0.20",
        "in_stock": "${i}0",
        "alert": "5",
        "received": [i + 20, 150]
      });
      i++;
    }
    return temps;
  }

  Future<void> initializeData(BuildContext context) async {
    headers = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: showID,
          sortable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        editable: true,
        textAlign: TextAlign.left,
      ),
      DatatableHeader(
          text: "SKU",
          value: "sku",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Category",
          value: "category",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Price",
          value: "price",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Margin",
          value: "margin",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "In Stock",
          value: "in_stock",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Alert",
          value: "alert",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Received",
          value: "received",
          show: true,
          sortable: false,
          sourceBuilder: (value, row) {
            List list = List.from(value);
            return Container(
              child: Column(
                children: [
                  Container(
                    width: 85,
                    child: LinearProgressIndicator(
                      value: list.first / list.last,
                    ),
                  ),
                  Text("${list.first} of ${list.last}")
                ],
              ),
            );
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "",
          value: "id",
          sourceBuilder: (value, row) {
            return IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.toString())));
                },
                icon: Icon(Icons.edit));
          },
          textAlign: TextAlign.center),
    ];

    await mockPullData();
  }

  Future<void> mockPullData() async {
    expanded = List.generate(currentPerPage!, (index) => false);

    isLoading = true;
    await Future.delayed(Duration(seconds: 1)).then((value) {
      sourceOriginal.clear();
      sourceOriginal.addAll(generateData(n: random.nextInt(100000)));
      sourceFiltered = sourceOriginal;
      total = sourceFiltered.length;
      source = sourceFiltered.getRange(0, currentPerPage!).toList();
      isLoading = false;
    });
  }

  Future<void> resetData({start = 0}) async {
    isLoading = true;
    var expandedLen =
        total - start < currentPerPage! ? total - start : currentPerPage;
    await Future.delayed(Duration(seconds: 5)).then((value) {
      expanded = List.generate(expandedLen as int, (index) => false);
      source.clear();
      source = sourceFiltered.getRange(start, start + expandedLen).toList();
      isLoading = false;
    });
  }

  void filterData(String value) {
    isLoading = true;

    try {
      if (value == "" || value == null) {
        sourceFiltered = sourceOriginal;
      } else {
        sourceFiltered = sourceOriginal
            .where((data) => data[searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      total = sourceFiltered.length;
      var rangeTop = total < currentPerPage! ? total : currentPerPage!;
      expanded = List.generate(rangeTop, (index) => false);
      source = sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }
}
