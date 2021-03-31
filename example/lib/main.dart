import 'package:adi_helpers/enumH.dart';
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
class Item {
  String name;
  int ram;
  int price;
  int storage;

  Item(this.name, this.ram, this.price, this.storage);
}

enum Item$ { name, ram, price, storage }

SortFilterFields_fn<Item> itemSortFilterFields = (item) => {
      string(Item$.name): item.name,
      string(Item$.ram): item.ram,
      string(Item$.price): item.price,
      string(Item$.storage): item.storage,
    };

var originalData = [
  Item("real me 6", 6, 18999, 1),
  Item("real me 6", 8, 19999, 128),
  Item("real Note 8", 7, 16999, 128),
  Item("oppo a9", 4, 13999, 64),
  Item("real me 6 pro", 6, 17999, 64),
  Item("Oppo 5as", 2, 8999, 32),
  Item("Real me 5i", 4, 10999, 64),
  Item("Poco x2", 6, 18500, 128),
];

class ExampleApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sort List Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ResusableDatagridW(
              data: originalData,
              fields: [
                ReusableDatagridFieldDefinition(fieldName: string(Item$.name), columnName: "Name", dataType: FilterDataType.string),
                ReusableDatagridFieldDefinition(fieldName: string(Item$.price), columnName: null, dataType: FilterDataType.number),
                ReusableDatagridFieldDefinition(fieldName: string(Item$.ram), columnName: null, dataType: FilterDataType.number),
                ReusableDatagridFieldDefinition(fieldName: string(Item$.storage), columnName: null, dataType: FilterDataType.number),
              ],
              itemSortFilterFields: itemSortFilterFields,
            ),
          ),
        ],
      ),
    );
  }
}
