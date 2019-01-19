import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class CoreUtils {
  // Get human readable file size string
  static String getFilesize(size, [int round = 2, bool decimal = false]) {
    int divider = 1024;

    size = int.parse(size.toString());

    if (decimal) divider = 1000;

    if (size < divider) return "$size B";

    if (size < divider * divider && size % divider == 0)
      return "${(size / divider).toStringAsFixed(0)} KB";

    if (size < divider * divider)
      return "${(size / divider).toStringAsFixed(round)} KB";

    if (size < divider * divider * divider && size % divider == 0)
      return "${(size / (divider * divider)).toStringAsFixed(0)} MB";

    if (size < divider * divider * divider)
      return "${(size / divider / divider).toStringAsFixed(round)} MB";

    if (size < divider * divider * divider * divider && size % divider == 0)
      return "${(size / (divider * divider * divider)).toStringAsFixed(0)} GB";

    if (size < divider * divider * divider * divider)
      return "${(size / divider / divider / divider).toStringAsFixed(round)} GB";

    if (size < divider * divider * divider * divider * divider &&
        size % divider == 0)
      return "${(size / divider / divider / divider / divider).toStringAsFixed(0)} TB";

    if (size < divider * divider * divider * divider * divider)
      return "${(size / divider / divider / divider / divider).toStringAsFixed(round)} TB";

    if (size < divider * divider * divider * divider * divider * divider &&
        size % divider == 0) {
      return "${(size / divider / divider / divider / divider / divider).toStringAsFixed(0)} PB";
    } else {
      return "${(size / divider / divider / divider / divider / divider).toStringAsFixed(round)} PB";
    }
  }

  static String generateAliasAcquisition(String deviceName) {
    var formatter = new DateFormat('yyyyMMddHHmmss');
    return formatter.format(new DateTime.now()) + deviceName.replaceAll("/", "_");
  }

  static bool compareListObjects(List list1, List list2) {
    Function eq = const ListEquality().equals;
    return(eq(list1, list2));
  }

  static List<DropdownMenuItem<String>> getDropdownMenuItems(List list) {
    List<DropdownMenuItem<String>> items = new List();

    if(list != null) {
      for (String element in list) {
        items.add(new DropdownMenuItem(
            value: element,
            child: new Text(element)
        ));
      }
    }

    return items;
  }

  static List<DropdownMenuItem<String>> getDropdownMenuItemsFromMap(Map map) {
    List<DropdownMenuItem<String>> items = new List();

    if(map != null) {
      for (String key in map.keys) {
        items.add(new DropdownMenuItem(
            value: key,
            child: new Text(map[key])
        ));
      }
    }

    return items;
  }
}
