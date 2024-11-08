class Middle {
  final String middle;
  final String s3Url;

  Middle({
    required this.middle,
    required this.s3Url
  });

  factory Middle.fromJson(Map<String, dynamic> json) {
    return Middle(
      middle: json['middle'] as String,
      s3Url: json['s3url'] as String,
    );
  }
}
