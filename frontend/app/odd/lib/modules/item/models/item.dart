class Item {
  final String itemId;
  final String itemName;
  final String platform;
  final List<String> serviceType;
  final int price;
  final String s3url;
  final int? purchaseCount;

  Item(
      {required this.itemId,
      required this.itemName,
      required this.platform,
      required this.serviceType,
      required this.price,
      required this.s3url,
      this.purchaseCount});

  // JSON 데이터 -> Item 객체로 변환
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        itemId: json['itemId'],
        itemName: json['itemName'],
        platform: json['platform'],
        serviceType: List<String>.from(json['serviceType']),
        price: json['price'],
        s3url: json['s3url'],
        purchaseCount: json['purchaseCount']);
  }
}
