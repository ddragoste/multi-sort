import 'package:flutter/material.dart';
import 'package:multi_sort/FilterBox.dart';
import 'package:multi_sort/ReusableDataGrid.dart';
import 'package:multi_sort/common.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExampleApp(),
    );
  }
}

/// Class of Items
class Item implements SortFilterable {
  String name;
  int ram;
  int price;
  int storage;
  Item(this.name, this.ram, this.price, this.storage);

  static const $name = 'name';
  static const $ram = 'ram';
  static const $price = 'price';
  static const $storage = 'storage';

  ///Mapping the properties
  Map<String, Comparable> sortFilterFields() {
    return {$name: name, $price: price, $ram: ram, $storage: storage};
  }
}

var originalData = List<Item>.generate(
    2000,
    (i) => //
        Item("id: $i", i * 2, i ~/ 2, i + 500));

//[
//  Item("real me 6", 6, 18999, 1),
//  Item("real me 6", 8, 19999, 128),
//  Item("real Note 8", 7, 16999, 128),
//  Item("oppo a9", 4, 13999, 64),
//  Item("real me 6 pro", 6, 17999, 64),
//  Item("Oppo 5as", 2, 8999, 32),
//  Item("Real me 5i", 4, 10999, 64),
//  Item("Poco x2", 6, 18500, 128),
//];

class ExampleApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ResusableDatagrid(
      data: originalData,
      fields: [
        ReusableDatagridFieldDefinition(fieldName: Item.$name, columnName: "Name", dataType: FilterDataType.string),
        ReusableDatagridFieldDefinition(fieldName: Item.$price, columnName: null, dataType: FilterDataType.number),
        ReusableDatagridFieldDefinition(fieldName: Item.$ram, columnName: null, dataType: FilterDataType.number),
        ReusableDatagridFieldDefinition(fieldName: Item.$storage, columnName: null, dataType: FilterDataType.number),
      ],
    );
  }
}

//
//class ExampleApp extends StatefulWidget {
//  ExampleApp({Key key}) : super(key: key);
//
//  _ExampleAppState createState() => _ExampleAppState();
//}
//
//class _ExampleAppState extends State<ExampleApp> {
//  //List of Items
//  var originalData = [
//    Item("real me 6", 6, 18999, 1),
//    Item("real me 6", 8, 19999, 128),
//    Item("real Note 8", 7, 16999, 128),
//    Item("oppo a9", 4, 13999, 64),
//    Item("real me 6 pro", 6, 17999, 64),
//    Item("Oppo 5as", 2, 8999, 32),
//    Item("Real me 5i", 4, 10999, 64),
//    Item("Poco x2", 6, 18500, 128),
//  ];
//
//  List<Item> data;
//
//  var sortedFields = <SortField>[];
//  var filteredFields = <FilterField>[];
//  var showFilter = false;
//
//  void initState() {
//    data = originalData;
//    super.initState();
//  }
//
//  void setSortedFields(List<SortField> sortedFields) {
//    setState(() {
//      this.sortedFields = sortedFields;
//      this.data = originalData.multiFilter(filteredFields).multisort(sortedFields);
//    });
//  }
//
//  void setFilteredFields(List<FilterField> filteredFields) {
//    setState(() {
//      this.filteredFields = filteredFields;
//      this.data = originalData.multisort(sortedFields).multiFilter(filteredFields);
//    });
//  }
//
//  void onShowFilter() {
//    setState(() => showFilter = !showFilter);
//  }
//
//  Widget build(BuildContext context) {
//    var container = SortableFilterableContainer(sortedFields, filteredFields, setSortedFields, setFilteredFields, showFilter, onShowFilter);
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Sort List Example"),
//      ),
//      body: DataTable(
//        headingRowHeight: showFilter ? 77 : 45,
//        columns: [
//          DataColumn(label: SortableFilterable(container, Item.$name, FilterDataType.string)),
//          DataColumn(label: SortableFilterable(container, Item.$price, FilterDataType.number)),
//          DataColumn(label: SortableFilterable(container, Item.$ram, FilterDataType.number)),
//          DataColumn(label: SortableFilterable(container, Item.$storage, FilterDataType.number)),
//          DataColumn(
//            label: InkWell(
//              child: Icon(
//                FontAwesomeIcons.search,
//                color: filteredFields.length == 0 ? Colors.black : Colors.blue,
//                size: filteredFields.length == 0 ? 10 : 15,
//              ),
//              onTap: container.onShowFilter,
//            ),
//          ),
//        ],
//        rows: data
//            .map(
//              (e) => DataRow(cells: <DataCell>[
//                DataCell(Text(e.name)),
//                DataCell(Text(e.price.toString())),
//                DataCell(Text(e.ram.toString())),
//                DataCell(Text(e.storage.toString())),
//                DataCell(Text('')),
//              ]),
//            )
//            .toList(),
//      ),
//    );
//  }
//}
