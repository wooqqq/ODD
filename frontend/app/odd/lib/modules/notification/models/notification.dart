class Notification {
  final String platform;
  final String content;
  final String date;

  Notification({
    required this.platform,
    required this.content,
    required this.date,
  });

  // JSON 데이터 -> Notification 객체
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      platform: json['platform'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    );
  }

}
