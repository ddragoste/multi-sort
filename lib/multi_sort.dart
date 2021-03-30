library multi_sort;

import 'common.dart';

class SortField {
  final String fieldName;
  final bool isAscending;

  SortField(this.fieldName, {this.isAscending = true});
}

extension MultiSort on List<SortFilterable> {
  List<SortFilterable> multisort(List<SortField> sortedFields) {
    if (sortedFields.length == 0) //
      return this;

    int compare(int i, SortFilterable a, SortFilterable b) {
      var valueA = getField(sortedFields[i].fieldName, a);
      var valueB = getField(sortedFields[i].fieldName, b);

      if (valueA == null) //
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
