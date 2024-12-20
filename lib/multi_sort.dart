library multi_sort;

import 'package:dartx/dartx.dart';

import 'common.dart';

class SortField {
  final String fieldName;
  final bool isAscending;

  SortField(this.fieldName, {this.isAscending = true});
}

extension MultiSort<T> on Iterable<SortFilterableItem<T>> {
  Iterable<SortFilterableItem<T>> sortedByFields(List<SortField> sortedFields) {
    if (sortedFields.length == 0) {
      return this;
    }

    SortedList<SortFilterableItem<T>> sortedList = sortedByField(
      sortedFields.first,
    );
    sortedFields.skip(1).forEach((sortField) {
      sortedList = sortedList.thenByField(sortField);
    });

    return sortedList;
  }

  SortedList<SortFilterableItem<T>> sortedByField(SortField field) {
    if (field.isAscending) {
      return sortedBy(
        (item) => item.sortFilterFields(item.value)[field.fieldName]!,
      );
    } else {
      return sortedByDescending(
        (item) => item.sortFilterFields(item.value)[field.fieldName]!,
      );
    }
  }
}

extension SortableByField<T> on SortedList<SortFilterableItem<T>> {
  SortedList<SortFilterableItem<T>> thenByField(SortField field) {
    if (field.isAscending) {
      return thenBy(
        (item) => item.sortFilterFields(item.value)[field.fieldName]!,
      );
    } else {
      return thenByDescending(
        (item) => item.sortFilterFields(item.value)[field.fieldName]!,
      );
    }
  }
}
