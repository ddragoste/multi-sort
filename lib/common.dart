///get function to get the properties of Item
///```
///Comparable? getField(String propertyName, SortFilterable sortable) {
///  var _mapRep = sortable.sortFilterFields();
///  var result = _mapRep[propertyName];
///
///  return result;
///}
///```

typedef SortFilterFieldsFn<T> = Map<String, Comparable?> Function(T);

class SortFilterableItem<T> {
  final T value;
  final SortFilterFieldsFn<T> sortFilterFields;

  SortFilterableItem(
    this.value,
    this.sortFilterFields,
  );

  Comparable? getField(String propertyName) {
    var _mapRep = sortFilterFields(this.value);
    var result = _mapRep[propertyName];

    return result;
  }

  String toString() => value.toString();
}

class DataTypeNotSupportedException implements Exception {
  final String message;

  DataTypeNotSupportedException(this.message);
}
