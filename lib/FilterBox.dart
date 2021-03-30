import 'package:flutter/material.dart';
import 'package:multi_sort/multi_filter.dart';

enum FilterDataType { string, number }

/// A filter to go with multi-filter to enable filtering of a list
/// If nothing is passed into the search string it will not be searched
class FilterBox extends StatefulWidget {
  /// The current list of filtered fields
  final List<FilterField> filteredFields;

  /// This field
  final String fieldName;

  /// The text for the button label
  final String? text;

  final void Function(List<FilterField>) onChange;

  final FilterDataType filterDataType;

  FilterBox(this.filteredFields, this.fieldName, this.onChange, this.filterDataType, {this.text});

  _FilterBoxState createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  void initState() {
    var listener = () {
      //just return the list, replacing the item with a new one
      var newFilteredFields1 = widget.filteredFields.where((e) => e.fieldName != widget.fieldName);
      late List<FilterField> newFilteredFields2;

      if (widget.filterDataType == FilterDataType.string) {
        newFilteredFields2 = [
          ...newFilteredFields1,
          FilterFieldString(fieldName: widget.fieldName, searchText: controller1.text),
        ];
      } else if (widget.filterDataType == FilterDataType.number) {
        newFilteredFields2 = [
          ...newFilteredFields1,
          FilterFieldNum(
            fieldName: widget.fieldName,
            from: controller1.text != '' ? double.parse(controller1.text) : null,
            to: controller2.text != '' ? double.parse(controller2.text) : null,
          )
        ];
      }
      widget.onChange(newFilteredFields2);
    };

    controller1.addListener(listener);
    controller2.addListener(listener);

    super.initState();
  }

  Widget build(BuildContext context) {
    if (widget.filterDataType == FilterDataType.string) {
      return Container(
        width: 60,
        child: TextField(
          controller: controller1,
        ),
      );
    } else if (widget.filterDataType == FilterDataType.number) {
      return Row(children: [
        Container(
          width: 30,
          child: TextField(
            controller: controller1,
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          width: 5,
        ),
        Container(
          width: 30,
          child: TextField(
            controller: controller2,
            keyboardType: TextInputType.number,
          ),
        ),
      ]);
    }

    throw Exception("unhandled filterDataType");
  }
}
