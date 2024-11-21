import 'item.dart';

class ItemList {
  final int pageNo;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool last;
  final List<Item> items;

  ItemList({
    required this.pageNo,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.last,
    required this.items,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      pageNo: json['pageNo'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      last: json['last'],
      items: List<Item>.from(json['items'].map((item) => Item.fromJson(item))),
    );
  }
}
