import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'FilterBox.dart';
import 'SortableFilterableContainer.dart';
import 'common.dart';
import 'multi_filter.dart';
import 'multi_sort.dart';

class ReusableDatagridFieldDefinition {
  final String fieldName;
  final String? columnName;
  final FilterDataType dataType;

  ReusableDatagridFieldDefinition({
    required this.fieldName,
    required this.columnName,
    required this.dataType,
  });
}

class ResusableDatagrid<TData extends SortFilterable> extends StatefulWidget {
  final List<TData> data;
  final List<ReusableDatagridFieldDefinition> fields;

  const ResusableDatagrid({Key? key, required this.data, required this.fields}) : super(key: key);

  _ResusableDatagridState createState() => _ResusableDatagridState();
}

class _ResusableDatagridState<TData extends SortFilterable> extends State<ResusableDatagrid<TData>> {
  late List<SortFilterable> data;
  var sortedFields = <SortField>[];
  var filteredFields = <FilterField>[];
  var showFilter = false;

  void initState() {
    data = widget.data;
    super.initState();
  }

  void setSortedFields(List<SortField> sortedFields) {
    setState(() {
      this.sortedFields = sortedFields;
      this.data = widget.data.multiFilter(filteredFields).multisort(sortedFields);
    });
  }

  void setFilteredFields(List<FilterField> filteredFields) {
    setState(() {
      this.filteredFields = filteredFields;
      this.data = widget.data.multisort(sortedFields).multiFilter(filteredFields);
    });
  }

  void onShowFilter() {
    setState(() => showFilter = !showFilter);
  }

  Widget build(BuildContext context) {
    var container = SortableFilterableContainer(sortedFields, filteredFields, setSortedFields, setFilteredFields, showFilter, onShowFilter);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sort List Example"),
      ),
      body: DataTable(
        headingRowHeight: showFilter ? 77 : 45,
        columns: [
          ...widget.fields
              .map((e) => DataColumn(
                    label: SortableFilterable(
                      container,
                      e.fieldName,
                      e.dataType,
                      buttonText: e.columnName,
                    ),
                  ))
              .toList(),
          DataColumn(
            label: InkWell(
              child: Icon(
                FontAwesomeIcons.search,
                color: filteredFields.length == 0 ? Colors.black : Colors.blue,
                size: filteredFields.length == 0 ? 10 : 15,
              ),
              onTap: container.onShowFilter,
            ),
          ),
        ],
        rows: data
            .map(
              (d) => DataRow(
                cells: [
                  ...widget.fields
                      .map(
                        (e) => DataCell(Text(getField(e.fieldName, d).toString())),
                      )
                      .toList(),
                  DataCell(Text('')),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
