library multi_filter;

import 'common.dart';

abstract class Filterable {}

abstract class FilterField {
  final String fieldName;

  FilterField(this.fieldName);
}

class FilterFieldString implements FilterField {
  final String fieldName;
  final String? searchText;

  FilterFieldString({required this.fieldName, this.searchText});
}

class FilterFieldNum implements FilterField {
  final String fieldName;
  final num? from;
  final num? to;

  FilterFieldNum({
    required this.fieldName,
    required this.from,
    required this.to,
  });
}

//extension MultiFilter on List<SortFilterable> {
extension MultiSort<T> on Iterable<SortFilterableItem<T>> {
  Iterable<SortFilterableItem<T>> multiFilter(List<FilterField> filteredFields) {
    if (filteredFields.length == 0) //
      return this;

    var list = this.where((item) {
      var result = true;

      for (var i = 0; i < filteredFields.length; ++i) {
        var filteredField = filteredFields[i];
        var value = item.getField(filteredField.fieldName);

        //can't filter for nulls
        if (value == null) //
          result = false;
        else {
          if (filteredField is FilterFieldString && value is String) {
            if (filteredField.searchText != null) //
              result = value.contains(filteredField.searchText!) && result;
          }

          if (filteredField is FilterFieldNum && value is num) {
            var from = filteredField.from ?? -2e53;
            var to = filteredField.to ?? 2e53;

            result = (value >= from && value <= to) && result;
          }
        }
      }

      return result;
    }).toList();

    return list;
  }
}
