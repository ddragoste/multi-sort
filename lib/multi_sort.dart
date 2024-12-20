library multi_sort;

import 'dart:core';

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
        (item) => _NullableComparator(
          item.sortFilterFields(item.value)[field.fieldName],
        ),
      );
    } else {
      return sortedByDescending(
        (item) => _NullableComparator(
          item.sortFilterFields(item.value)[field.fieldName],
        ),
      );
    }
  }
}

extension SortableByField<T> on SortedList<SortFilterableItem<T>> {
  SortedList<SortFilterableItem<T>> thenByField(SortField field) {
    if (field.isAscending) {
      return thenBy(
        (item) => _NullableComparator(
          item.sortFilterFields(item.value)[field.fieldName],
        ),
      );
    } else {
      return thenByDescending(
        (item) => _NullableComparator(
          item.sortFilterFields(item.value)[field.fieldName],
        ),
      );
    }
  }
}

class _NullableComparator implements Comparable<dynamic> {
  final Comparable<dynamic>? value;

  _NullableComparator(this.value);

  @override
  int compareTo(dynamic other) {
    if (value == null && other == null) {
      return 0;
    }

    if (other is _NullableComparator) {
      other = other.value;
    }

    if (other == null) {
      return 1;
    }

    if (value == null) {
      return -1;
    }

    if (other is _NullableComparator) {
      other = other.value;
    }

    return value!.compareTo(other);
  }
}
