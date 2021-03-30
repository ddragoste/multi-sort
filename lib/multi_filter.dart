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

extension MultiFilter on List<SortFilterable> {
  List<SortFilterable> multiFilter(List<FilterField> filteredFields) {
    if (filteredFields.length == 0) //
      return this;

    var list = this.where((item) {
      var result = true;

      for (var i = 0; i < filteredFields.length; ++i) {
        var filteredField = filteredFields[i];
        var value = getField(filteredField.fieldName, item);

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

//        if (value is String) {
//          var filteredFieldStr = filteredField as FilterFieldString;
//          if (filteredFieldStr.searchText == null) //
//            return true;
//          return value.contains(filteredFieldStr.searchText!);
//        }
//
//        if (value is num) {
//          var filteredFieldNum = (filteredField as FilterFieldNum);
//
//          var from = filteredFieldNum.from ?? -2e53;
//          var to = filteredFieldNum.to ?? 2e53;
//
//          return value >= from && value <= to;
//        }
//        throw DataTypeNotSupportedException(value.runtimeType.toString());
      }

      return result;
    }).toList();

    return list;
  }
}
