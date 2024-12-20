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

  Item(
    this.name,
    this.ram,
    this.price,
    this.storage,
  );
}

enum Item$ {
  name,
  ram,
  price,
  storage,
}

SortFilterFieldsFn<Item> itemSortFilterFields = (item) => {
      Item$.name.name: item.name,
      Item$.ram.name: item.ram,
      Item$.price.name: item.price,
      Item$.storage.name: item.storage,
    };

var originalData = List<Item>.generate(
  2000,
  (i) => Item(
    "id: $i",
    i * 2,
    i ~/ 2,
    i + 500,
  ),
);

class ExampleApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sort List Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: DataGridWidget<Item>(
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
          ),
        ],
      ),
    );
  }
}
