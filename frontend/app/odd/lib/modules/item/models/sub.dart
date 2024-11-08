class Sub {
  final String sub;

  Sub({
    required this.sub
  });

  // JSON 데이터를 기반으로 Sub 객체 생성
  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      sub: json['sub'] as String,
    );
  }
}
