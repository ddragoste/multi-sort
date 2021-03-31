library multi_sort;

import 'common.dart';

class SortField {
  final String fieldName;
  final bool isAscending;

  SortField(this.fieldName, {this.isAscending = true});
}

extension MultiSort<T> on Iterable<SortFilterableItem<T>> {
  Iterable<SortFilterableItem<T>> multisort(List<SortField> sortedFields) {
    if (sortedFields.length == 0) //
      return this;

    int compare(int i, SortFilterableItem<T> a, SortFilterableItem<T> b) {
      var valueA = a.getField(sortedFields[i].fieldName);
      var valueB = b.getField(sortedFields[i].fieldName);

      if (valueA == null && valueB == null) //
        return 0;

      if (valueA == null) //
        return 1;

      if (valueB == null) //
        return -1;

      int result;
      if (valueA is String && valueB is String) //
        result = valueA.toUpperCase().compareTo(valueB.toUpperCase());
      else //
        result = valueA.compareTo(valueB);

      if (!sortedFields[i].isAscending) //
        return result * -1;

      return result;
    }

    int sortall(a, b) {
      int i = 0;
      late int result;
      while (i < sortedFields.length) {
        result = compare(i, a, b);
        if (result != 0) break;
        i++;
      }
      return result;
    }

    final list = this.toList();

    list.sort((a, b) => sortall(a, b));

    return list;
  }
}
