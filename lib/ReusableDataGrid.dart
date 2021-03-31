import 'package:atreeon_flutter_reuse/MeasureSize.dart';
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
    required this.dataType,
    this.columnName,
  });
}

class ResusableDatagridW<T> extends StatefulWidget {
  final List<T> data;
  final List<ReusableDatagridFieldDefinition> fields;
  final SortFilterFields_fn<T> itemSortFilterFields;
  final int rowHeight;

  ResusableDatagridW({
    Key? key,
    required this.data,
    required this.fields,
    required this.itemSortFilterFields,
    this.rowHeight = 30,
  }) : super(key: key);
  _ResusableDatagridW<T> createState() => _ResusableDatagridW();
}

class _ResusableDatagridW<T> extends State<ResusableDatagridW<T>> {
  late Iterable<SortFilterableItem<T>> data;
  var sortedFields = <SortField>[];
  var filteredFields = <FilterField>[];
  var showFilter = false;
  var myChildSize = Size(10, 10);
  var rowsPerPage = 10;
  late int rowHeight;
  var widgetSize = Size(100, 100);

  void initState() {
    data = widget.data.map((e) => SortFilterableItem<T>(e, widget.itemSortFilterFields));
    rowHeight = widget.rowHeight;
    super.initState();
  }

  void setSortedFields(List<SortField> sortedFields) {
    setState(() {
      this.sortedFields = sortedFields;
      data = widget.data.map((e) => //
          SortFilterableItem(e, widget.itemSortFilterFields)).multiFilter(filteredFields).multisort(sortedFields);
    });
  }

  void setFilteredFields(List<FilterField> filteredFields) {
    setState(() {
      this.filteredFields = filteredFields;
      data = widget.data.map((e) => //
          SortFilterableItem(e, widget.itemSortFilterFields)).multiFilter(filteredFields).multisort(sortedFields);
    });
  }

  void onShowFilter() {
    setState(() => showFilter = !showFilter);
    onSizeChange(widgetSize);
  }

  void onSizeChange(Size size) {
    setState(() {
      rowsPerPage = (size.height - (showFilter ? 150 : 110)) ~/ (rowHeight);
      widgetSize = size;
    });
  }

  Widget build(BuildContext context) {
    var container = SortableFilterableContainer(sortedFields, filteredFields, setSortedFields, setFilteredFields, showFilter, onShowFilter);

    return Scaffold(
        appBar: AppBar(
          title: Text("Sort List Example"),
        ),
        body: Column(
          children: [
            Expanded(
              child: MeasureSize(
                onChange: (size) {
                  onSizeChange(size);
                },
                child: PaginatedDataTable(
                  dataRowHeight: rowHeight.toDouble(),
                  source: DTS(data.toList(), widget.fields),
                  headingRowHeight: showFilter ? 77 : 45,
                  rowsPerPage: rowsPerPage,
                  columns: [
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
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class DTS<TData> extends DataTableSource {
  final List<SortFilterableItem<TData>> data;
  final List<ReusableDatagridFieldDefinition> fields;

  DTS(this.data, this.fields);

  DataRow getRow(int i) {
    return DataRow.byIndex(
      index: i,
      cells: [
        DataCell(Text('')),
        ...fields
            .map(
              (e) => DataCell(Text(data[i].getField(e.fieldName).toString())),
            )
            .toList(),
      ],
    );
  }

  int get rowCount => data.length; // Manipulate this to which ever value you wish

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}
