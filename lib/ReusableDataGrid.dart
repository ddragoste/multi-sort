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

class ResusableDatagrid<TData extends SortFilterable> extends StatefulWidget {
  final List<TData> data;
  final List<ReusableDatagridFieldDefinition> fields;
  final int rowHeight;

  const ResusableDatagrid({Key? key, required this.data, required this.fields, this.rowHeight = 30}) : super(key: key);

  _ResusableDatagridState createState() => _ResusableDatagridState();
}

class _ResusableDatagridState<TData extends SortFilterable> extends State<ResusableDatagrid<TData>> {
  late List<SortFilterable> data;
  var sortedFields = <SortField>[];
  var filteredFields = <FilterField>[];
  var showFilter = false;
  var myChildSize = Size(10, 10);
  var rowsPerPage = 10;
  late int rowHeight;
  var widgetSize = Size(100, 100);

  void initState() {
    data = widget.data;
    rowHeight = widget.rowHeight;
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
                  source: DTS(data, widget.fields),
                  headingRowHeight: showFilter ? 77 : 45,
                  rowsPerPage: rowsPerPage,
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
                ),
              ),
            )
          ],
        ));
  }
}

class DTS<TData extends SortFilterable> extends DataTableSource {
  final List<TData> data;
  final List<ReusableDatagridFieldDefinition> fields;

  DTS(this.data, this.fields);

  DataRow getRow(int i) {
    return DataRow.byIndex(
      index: i,
      cells: [
        ...fields
            .map(
              (e) => DataCell(Text(getField(e.fieldName, data[i]).toString())),
            )
            .toList(),
        DataCell(Text('')),
      ],
    );
  }

  int get rowCount => data.length; // Manipulate this to which ever value you wish

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}
