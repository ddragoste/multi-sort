import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'multi_sort.dart';

/// A button to go with multi-sort to toggle sorting on multiple fields
class SortableButton extends StatelessWidget {
  /// The current list of sorted fields
  final List<SortField> sortedFields;

  /// This field
  final String fieldName;

  /// The text for the button label
  final String? buttonText;

  final void Function(List<SortField>) onPressed;

  SortableButton(
    this.sortedFields,
    this.fieldName,
    this.onPressed, {
    this.buttonText,
  });

  Widget build(BuildContext context) {
    SortField? thisSortedField;
    int? index;

    sortedFields.forEachIndexed(
      (e, i) {
        if (e.fieldName == fieldName) {
          index = i + 1;
          thisSortedField = e;
        }
      },
    );

    return TextButton(
      onPressed: () {
        var newSortedFields = <SortField>[];

        if (thisSortedField == null) {
          newSortedFields = [
            ...sortedFields,
            SortField(fieldName),
          ];
        } else {
          if (thisSortedField!.isAscending) {
            newSortedFields = sortedFields
                .map(
                  (e) => e.fieldName != thisSortedField!.fieldName
                      ? e
                      : SortField(e.fieldName, isAscending: false),
                )
                .toList();
          } else
            newSortedFields = sortedFields
                .where(
                  (e) => e.fieldName != thisSortedField!.fieldName,
                )
                .toList();
        }

        onPressed(newSortedFields);
      },
      child: Row(
        children: [
          if (thisSortedField != null) ...[
            Icon(
              thisSortedField!.isAscending
                  ? FontAwesomeIcons.angleUp
                  : FontAwesomeIcons.angleDown,
              size: 15,
            ),
            Text(
              index.toString(),
              textScaler: TextScaler.linear(0.6),
            ),
          ],
          Text(this.buttonText ?? fieldName),
        ],
      ),
    );
  }
}
