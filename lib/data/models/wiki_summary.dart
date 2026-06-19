class WikiSummary {
  const WikiSummary({
    required this.title,
    required this.extract,
    this.pageUrl,
  });

  final String title;
  final String extract;
  final String? pageUrl;

  factory WikiSummary.fromJson(Map<String, dynamic> json) {
    final urls = json['content_urls'] as Map<String, dynamic>?;
    final desktop = urls?['desktop'] as Map<String, dynamic>?;
    return WikiSummary(
      title: json['title'] as String? ?? '',
      extract: json['extract'] as String? ?? '',
      pageUrl: desktop?['page'] as String?,
    );
  }
}
