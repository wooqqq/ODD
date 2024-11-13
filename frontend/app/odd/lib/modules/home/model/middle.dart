class Middle {
  final String middle;
  final String s3url;

  Middle({
    required this.middle,
    required this.s3url
  });

  factory Middle.fromJson(Map<String, dynamic> json) {
    return Middle(
      middle: json['middle'] as String,
      s3url: json['s3url'] as String,
    );
  }
}
