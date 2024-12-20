import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'filter_box.dart';
import 'multi_filter.dart';
import 'multi_sort.dart';
import 'sortable_button.dart';

class SortableFilterableContainer {
  final List<SortField> sortedFields;
  final List<FilterField> filteredFields;
  final void Function(List<SortField>) onPressed;
  final void Function(List<FilterField>) onChanged;
  final bool showFilter;
  final void Function() onShowFilter;

  SortableFilterableContainer(
    this.sortedFields,
    this.filteredFields,
    this.onPressed,
    this.onChanged,
    this.showFilter,
    this.onShowFilter,
  );
}

class SortableFilterable extends StatelessWidget {
  final SortableFilterableContainer container;
  final String fieldName;
  final String? buttonText;
  final FilterDataType filterDataType;

  const SortableFilterable(
    this.container,
    this.fieldName,
    this.filterDataType, {
    this.buttonText,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          child: FilterBox(
            container.filteredFields,
            fieldName,
            container.onChanged,
            filterDataType,
          ),
          visible: container.showFilter,
          maintainState: true,
        ),
        SortableButton(
          container.sortedFields,
          fieldName,
          container.onPressed,
          buttonText: this.buttonText,
        ),
      ],
    );
  }
}
