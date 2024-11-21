class NotificationModel {
  final String? itemId;
  final String platform;
  final String content;
  final String date;

  NotificationModel({
    this.itemId,
    required this.platform,
    required this.content,
    required this.date,
  });

  // JSON 데이터 -> Notification 객체
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      itemId: json['itemId'] as String?,
      platform: json['platform'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    );
  }
}
