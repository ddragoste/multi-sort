import 'package:flutter/material.dart';
import 'package:multi_sort/common.dart';
import 'package:multi_sort/data_grid_widget.dart';
import 'package:multi_sort/filter_box.dart';

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

SortFilterFieldsFn<Item> itemSortFilterFields = (item) => {
      Item$.name.name: item.name,
      Item$.ram.name: item.ram,
      Item$.price.name: item.price,
      Item$.storage.name: item.storage,
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
      body: DataGridWidget(
        data: originalData,
        fields: [
          DataGridFieldDefinition(
            fieldName: Item$.name.name,
            columnName: "Name",
            dataType: FilterDataType.string,
          ),
          DataGridFieldDefinition(
            fieldName: Item$.price.name,
            columnName: null,
            dataType: FilterDataType.number,
          ),
          DataGridFieldDefinition(
            fieldName: Item$.ram.name,
            columnName: null,
            dataType: FilterDataType.number,
          ),
          DataGridFieldDefinition(
            fieldName: Item$.storage.name,
            columnName: null,
            dataType: FilterDataType.number,
          ),
        ],
        itemSortFilterFields: itemSortFilterFields,
      ),
    );
  }
}
