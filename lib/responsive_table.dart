import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class DataPage extends StatefulWidget {
  DataPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;

  // Todo : For the purpose of testing if we can hide a column from the view
  bool _showID = true;
  
  bool _showSelect = false;

  List<int> _perPages = [10, 20, 50, 100, 1000];
  int _total = 10000;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  var random = new Random();

  List<Map<String, dynamic>> _generateData(int n) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = [];
    var i = 1;
    print(i);
    // ignore: unused_local_variable
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

  _initializeData() async {
    /// set headers
    _headers = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: _showID,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        editable: true,
        textAlign: TextAlign.left,
        // sourceBuilder: (value, row) {
        //   return Text(' -- $value');
        // },
        // headerBuilder: (value) {
        //   print(value);
        //   return Text('Names');
        // },
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
            return Column(
              children: [
                Container(
                  width: 85,
                  child: LinearProgressIndicator(
                    value: list.first / list.last,
                  ),
                ),
                Text("${list.first} of ${list.last}")
              ],
            );
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "",
          value: "id",
          sourceBuilder: (value, row) {
            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value.toString())));
                    },
                    icon: Icon(Icons.open_in_new)),
                IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value.toString())));
                    },
                    icon: Icon(Icons.edit)),
              ],
            );
          },
          textAlign: TextAlign.center),
    ];

    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(_total));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 5)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var search = Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText:
                'Enter search term based on ${_searchKey!.replaceAll(RegExp('[\\W_]+'), ' ').toUpperCase()}',
            prefixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _isSearch = false;
                  });
                  _initializeData();
                }),
            suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {})),
        onSubmitted: (value) {
          if (value.isNotEmpty) _filterData(value);
        },
      ),
    ));
    var headerActions = [
      if (_isSearch) search,
      if (!_isSearch)
        Row(children: [
          InkWell(
            onTap: () {
              setState(() {
                _showSelect = !_showSelect;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Text("Show"),
                  Checkbox(
                      value: _showSelect,
                      onChanged: (value) {
                        setState(() {
                          _showSelect = value!;
                        });
                      })
                ],
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearch = true;
                });
              })
        ]),
    ];
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                reponseScreenSizes: [
                  ScreenSize.xs,
                  ScreenSize.sm,
                  ScreenSize.md
                ],

                // Uncomment this and youll know hehe custom view for mobile
                // You can now customize Mobile view Rows here
                commonMobileView: true,
                isExpandRows: true,

                actions: headerActions,
                headers: _headers,
                source: _source,
                selecteds: _selecteds,
                showSelect: _showSelect,

                autoHeight: false,
                dropContainer: (data) {
                  // if (int.tryParse(data['id'].toString())!.isEven) {
                  //   return Text("is Even");
                  // }
                  return _DropDownContainer(data: data);
                },
                onChangedRow: (value, header) {
                  print('onSubmitRow Value: $value');
                  print('onSubmitRow Header: $header');
                },
                onSubmittedRow: (value, header) {
                  print('onSubmitRow Value: $value');
                  print('onSubmitRow Header: $header');
                },
                onTabRow: (data) {
                  print('onTabRow: $data');
                  print(data['id']);
                },
                onSort: (value) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.toString())));

                  setState(() => _isLoading = true);

                  setState(() {
                    _sortColumn = value;
                    _sortAscending = !_sortAscending;
                    if (_sortAscending) {
                      _sourceFiltered.sort((a, b) =>
                          b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                    } else {
                      _sourceFiltered.sort((a, b) =>
                          a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                    }
                    var _rangeTop = _currentPerPage! < _sourceFiltered.length
                        ? _currentPerPage!
                        : _sourceFiltered.length;
                    _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                    _searchKey = value;

                    _isLoading = false;
                  });
                },
                expanded: _expanded,
                sortAscending: _sortAscending,
                sortColumn: _sortColumn,
                isLoading: _isLoading,
                onSelect: (value, item) {
                  print("$value  $item ");
                  if (value!) {
                    setState(() => _selecteds.add(item));
                  } else {
                    setState(
                        () => _selecteds.removeAt(_selecteds.indexOf(item)));
                  }
                },
                onSelectAll: (value) {
                  if (value!) {
                    setState(() => _selecteds =
                        _source.map((entry) => entry).toList().cast());
                  } else {
                    setState(() => _selecteds.clear());
                  }
                },
                footers: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Rows:"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<int>(
                      value: _currentPerPage,
                      items: _perPages
                          .map((e) => DropdownMenuItem<int>(
                                child: Text("$e"),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          _currentPerPage = value;
                          _currentPage = 1;
                          _resetData();
                        });
                      },
                      isExpanded: false,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: _currentPage == 1
                            ? null
                            : () {
                                var _nextSet = _currentPage - _currentPerPage!;
                                setState(() {
                                  _currentPage = _nextSet > 1 ? _nextSet : 1;
                                  _resetData(start: _currentPage - 1);
                                });
                              },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _currentPage + _currentPerPage! - 1 > _total
                            ? null
                            : () {
                                var _nextSet = _currentPage + _currentPerPage!;

                                setState(() {
                                  _currentPage = _nextSet < _total
                                      ? _nextSet
                                      : _total - _currentPerPage!;
                                  _resetData(start: _nextSet - 1);
                                });
                              },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("$_currentPage - $_currentPerPage of $_total"),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _showID = !_showID;
                        });
                        _initializeData();
                      },
                      child: Text('hide ID'))
                ],
                headerDecoration: BoxDecoration(
                    color: Colors.blue[400],
                    border: Border(
                        bottom: BorderSide(color: Colors.red, width: 1))),
                selectedDecoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.red[400]!, width: 1)),
                  color: Colors.green,
                ),
                headerTextStyle: TextStyle(color: Colors.white),
                rowTextStyle: TextStyle(color: Colors.green),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]));
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<Widget> _children = data.entries.map<Widget>((entry) {
    //   // Widget w = Row(
    //   //   children: [
    //   //     Text(entry.key.toString()),
    //   //     Spacer(),
    //   //     Text(entry.value.toString()),
    //   //   ],
    //   // );

    //   print(entry.value);

    //   Widget w = ListTile(
    //     title: Text(entry.key.toString()),
    //     trailing: Text(entry.value.toString()),
    //   );
    //   return w;
    // }).toList();

    // return Container(
    //   /// height: 100,
    //   child: Column(
    //     // / children: [
    //     // /   Expanded(
    //     // /       child: Container(
    //     // /     color: Colors.red,
    //     // /     height: 50,
    //     // /   )),
    //     // / ],
    //     children: _children,
    //   ),
    // );

    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text('Product name: ${data["name"]}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ${data["price"].toString()}'),
                Text('Cost: ${data["cost"].toString()}')
              ],
            ),
            trailing: ElevatedButton(
              child: Text('Action'),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
