class Sub {
  final String sub;

  Sub({
    required this.sub
  });

  // JSON 데이터 -> Sub 객체로 변환
  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      sub: json['sub'] as String,
    );
  }
}
