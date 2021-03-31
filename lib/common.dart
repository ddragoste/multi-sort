/////get function to get the properties of Item
//Comparable? getField(String propertyName, SortFilterable sortable) {
//  var _mapRep = sortable.sortFilterFields();
//  var result = _mapRep[propertyName];
//
//  return result;
//}

typedef SortFilterFields_fn<T> = Map<String, Comparable?> Function(T);

class SortFilterableItem<T> {
  final T item;
  final SortFilterFields_fn<T> sortFilterFields;

  SortFilterableItem(this.item, this.sortFilterFields);

  Comparable? getField(String propertyName) {
    var _mapRep = sortFilterFields(this.item);
    var result = _mapRep[propertyName];

    return result;
  }

  String toString() => item.toString();
}

class DataTypeNotSupportedException implements Exception {
  final String message;

  DataTypeNotSupportedException(this.message);
}
