//flutter test --plain-name=LessonSplitter

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_sort/common.dart';
import 'package:multi_sort/multi_filter.dart';

class Unsupported implements Comparable<dynamic> {
  int compareTo(other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }
}

/// Class of Items
class Phone {
  final String name;
  final int ram;
  final double? cost;
  final Unsupported? unsupported;

  Phone(this.name, this.ram, {this.unsupported, this.cost});

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}, unsupported: ${this.unsupported}, cost: ${this.cost} ";
}

Map<String, Comparable?> itemSortFilterFields(Phone phone) => {
      'name': phone.name,
      'ram': phone.ram,
      'unsupported': phone.unsupported,
      'cost': phone.cost,
    };

void main() {
  group("filterSort", () {
    var originalList = [
      Phone("Adrian", 1),
      Phone("Bob", 128),
      Phone("Andrew", 64, cost: 5000),
    ];
    var list = originalList.map((e) => SortFilterableItem(e, itemSortFilterFields));

    test("1 filter by text", () {
      var filterFields = [
        FilterFieldString(fieldName: 'name', searchText: 'A'),
      ];
      var sorted = list.multiFilter(filterFields);
      var expected = [
        Phone("Adrian", 1),
        Phone("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

//    test("2 type not found", () {
//      var filterFields = [
//        FilterFieldString(fieldName: 'unsupported', searchText: 'A'),
//      ];
//      expect(() => unsorted.multiFilter(filterFields), throwsA(TypeMatcher<DataTypeNotSupportedException>()));
//    });

    test("3 filter by number", () {
      var filterFields = [
        FilterFieldNum(fieldName: 'ram', from: 63, to: null),
      ];
      var sorted = list.multiFilter(filterFields);
      var expected = [
        Phone("Bob", 128),
        Phone("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("4 filter by nullable double", () {
      var filterFields = [
        FilterFieldNum(fieldName: 'cost', from: 2000, to: null),
      ];
      var sorted = list.multiFilter(filterFields);
      var expected = [
        Phone("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("5 filter not set", () {
      var filterFields = [
        FilterFieldString(fieldName: 'name', searchText: null),
      ];
      var sorted = list.multiFilter(filterFields);
      var expected = [
        Phone("Adrian", 1),
        Phone("Bob", 128),
        Phone("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("6 two filters", () {
      var filterFields = [
        FilterFieldString(fieldName: 'name', searchText: "A"),
        FilterFieldNum(fieldName: 'ram', from: null, to: 5),
      ];
      var sorted = list.multiFilter(filterFields);
      var expected = [
        Phone("Adrian", 1),
//        Items("Bob", 128),
//        Items("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });
  });
}

///// A matcher for functions that throw Exception.
//const Matcher throwsDataTypeNotSupportedException = Throws(isDataTypeNotSupportedException);
//const isDataTypeNotSupportedException = const TypeMatcher<DataTypeNotSupportedException>();

/// A matcher for functions that throw Exception.
//const Matcher throwsException = throwsA(DataTypeNotSupportedException);
