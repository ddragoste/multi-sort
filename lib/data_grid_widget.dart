import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:measure_size/measure_size.dart';

import 'common.dart';
import 'filter_box.dart';
import 'multi_filter.dart';
import 'multi_sort.dart';
import 'sortable_filterable_container.dart';

class DataGridFieldDefinition {
  final String fieldName;
  final String? columnName;
  final FilterDataType dataType;

  DataGridFieldDefinition({
    required this.fieldName,
    required this.dataType,
    this.columnName,
  });
}

class DataGridWidget<T> extends StatefulWidget {
  final List<T> data;
  final List<DataGridFieldDefinition> fields;
  final SortFilterFieldsFn<T> itemSortFilterFields;
  final int rowHeight;

  DataGridWidget({
    Key? key,
    required this.data,
    required this.fields,
    required this.itemSortFilterFields,
    this.rowHeight = 30,
  }) : super(key: key);
  _DataGridWidgetState<T> createState() => _DataGridWidgetState();
}

class _DataGridWidgetState<T> extends State<DataGridWidget<T>> {
  late Iterable<SortFilterableItem<T>> data;
  var sortedFields = <SortField>[];
  var filteredFields = <FilterField>[];
  var showFilter = false;
  var myChildSize = Size(10, 10);
  var rowsPerPage = 10;
  late int rowHeight;
  var widgetSize = Size(100, 100);

  void initState() {
    data = widget.data.map(
      (e) => SortFilterableItem<T>(e, widget.itemSortFilterFields),
    );
    rowHeight = widget.rowHeight;
    super.initState();
  }

  void setSortedFields(List<SortField> sortedFields) {
    setState(
      () {
        this.sortedFields = sortedFields;
        data = widget.data
            .map(
              (e) => SortFilterableItem(e, widget.itemSortFilterFields),
            )
            .multiFilter(filteredFields)
            .sortedByFields(sortedFields);
      },
    );
  }

  void setFilteredFields(List<FilterField> filteredFields) {
    setState(
      () {
        this.filteredFields = filteredFields;
        data = widget.data
            .map((e) => //
                SortFilterableItem(e, widget.itemSortFilterFields))
            .multiFilter(filteredFields)
            .sortedByFields(sortedFields);
      },
    );
  }

  void onShowFilter() {
    setState(
      () => showFilter = !showFilter,
    );
    onSizeChange(widgetSize);
  }

  void onSizeChange(Size size) {
    setState(
      () {
        rowsPerPage = (size.height - (showFilter ? 158 : 110)) ~/ (rowHeight);
        widgetSize = size;
      },
    );
  }

  Widget build(BuildContext context) {
    var container = SortableFilterableContainer(
      sortedFields,
      filteredFields,
      setSortedFields,
      setFilteredFields,
      showFilter,
      onShowFilter,
    );

    return MeasureSize(
      onChange: (size) {
        onSizeChange(size);
      },
      child: PaginatedDataTable(
        dataRowMinHeight: rowHeight.toDouble(),
        dataRowMaxHeight: rowHeight.toDouble(),
        source: DTS(data.toList(), widget.fields),
        headingRowHeight: showFilter ? 110 : 50,
        rowsPerPage: rowsPerPage,
        columns: [
          DataColumn(
            label: InkWell(
              child: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: filteredFields.length == 0 ? Colors.black : Colors.blue,
                size: filteredFields.length == 0 ? 10 : 15,
              ),
              onTap: container.onShowFilter,
            ),
          ),
          ...widget.fields
              .map(
                (e) => DataColumn(
                  label: SortableFilterable(
                    container,
                    e.fieldName,
                    e.dataType,
                    buttonText: e.columnName,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class DTS<TData> extends DataTableSource {
  final List<SortFilterableItem<TData>> data;
  final List<DataGridFieldDefinition> fields;

  DTS(this.data, this.fields);

  DataRow getRow(int i) {
    return DataRow.byIndex(
      index: i,
      cells: [
        DataCell(Text('')),
        ...fields
            .map(
              (e) => DataCell(
                Text(
                  data[i].getField(e.fieldName).toString(),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  int get rowCount =>
      data.length; // Manipulate this to which ever value you wish

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}
