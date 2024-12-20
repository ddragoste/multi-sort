//flutter test --plain-name=LessonSplitter

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_sort/common.dart';
import 'package:multi_sort/multi_sort.dart';

// Class of Phone
class Phone {
  final String name;
  final int ram;

  Phone(this.name, this.ram);

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}";
}

Map<String, Comparable?> itemSortFilterFields(Phone phone) => {
      'name': phone.name,
      'ram': phone.ram,
    };

class NullablePhone {
  final String name;
  final int? ram;

  NullablePhone(this.name, this.ram);

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}";
}

Map<String, Comparable?> itemSortFilterFields2(NullablePhone phone) => {
      'name': phone.name,
      'ram': phone.ram,
    };

void main() {
  group("multiSort", () {
//    List<Phone> unsorted;

    var originalList = [
      Phone("b", 1),
      Phone("b", 128),
      Phone("a", 64),
    ];
    var list =
        originalList.map((e) => SortFilterableItem(e, itemSortFilterFields));

    test("two asc", () {
      var sortedFields = [
        SortField('ram'),
        SortField('name'),
      ];
      var sorted = list.sortedByFields(sortedFields).toList();
      var expected = [
        Phone("b", 1),
        Phone("a", 64),
        Phone("b", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("two asc & desc", () {
      var sortedFields = [
        SortField('name'),
        SortField('ram', isAscending: false),
      ];
      var sorted = list.sortedByFields(sortedFields).toList();
      var expected = [
        Phone("a", 64),
        Phone("b", 128),
        Phone("b", 1),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sort set to null", () {
      var sortedFields = <SortField>[];
      var sorted = list.sortedByFields(sortedFields).toList();
      var expected = [
        Phone("b", 1),
        Phone("b", 128),
        Phone("a", 64),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sorting on nulls descending", () {
      var originalList = [
        NullablePhone("b", null),
        NullablePhone("b", 128),
        NullablePhone("a", null),
      ];
      var list =
          originalList.map((e) => SortFilterableItem(e, itemSortFilterFields2));

      var sortedFields = <SortField>[
        SortField('ram', isAscending: false),
        SortField('name', isAscending: false),
      ];
      var sorted = list.sortedByFields(sortedFields).toList();
      var expected = [
        NullablePhone("b", 128),
        NullablePhone("b", null),
        NullablePhone("a", null),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sorting on nulls ascending", () {
      var originalList = [
        NullablePhone("b", null),
        NullablePhone("b", 128),
        NullablePhone("a", null),
      ];
      var list =
          originalList.map((e) => SortFilterableItem(e, itemSortFilterFields2));

      var sortedFields = <SortField>[
        SortField('name', isAscending: true),
        SortField('ram', isAscending: true),
      ];
      var sorted = list.sortedByFields(sortedFields).toList();
      var expected = [
        NullablePhone("a", null),
        NullablePhone("b", null),
        NullablePhone("b", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });
  });
}
