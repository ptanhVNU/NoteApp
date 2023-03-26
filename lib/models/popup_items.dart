import 'package:flutter/material.dart';
import 'package:task_manager/models/popup_item.dart';

class PopUpItems {
  static const List<PopUpItem> itemFirst = [
    itemSortBy,
  ];

  static const List<PopUpItem> itemSecond = [
    itemHigh,
    itemLow,
  ];

  static const itemSortBy = PopUpItem(
    'Sort By',
    Icons.arrow_right_outlined,
  );
  static const itemSortByLeft = PopUpItem(
    'Sort By',
    Icons.arrow_left_outlined,
  );

  static const itemHigh = PopUpItem(
    'High Priority',
    Icons.arrow_drop_up,
  );
  static const itemLow = PopUpItem(
    'Low Priority',
    Icons.arrow_drop_down,
  );
}
