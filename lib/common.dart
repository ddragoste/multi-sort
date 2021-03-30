///get function to get the properties of Item
Comparable? getField(String propertyName, SortFilterable sortable) {
  var _mapRep = sortable.sortFilterFields();
  var result = _mapRep[propertyName];

  return result;
}

abstract class SortFilterable {
  ///A list of strings and their textual ids eg
  ///
  /// {'name': name, 'price': price, 'ram': ram, 'storage': storage};
  Map<String, Comparable?> sortFilterFields();
}

class DataTypeNotSupportedException implements Exception {
  final String message;

  DataTypeNotSupportedException(this.message);
}
