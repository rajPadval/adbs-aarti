class Article {
  final int id;
  final String title;
  final String lyrics;

  Article({
    required this.id,
    required this.title,
    required this.lyrics,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      lyrics: json['lyrics'] as String,
    );
  }
}
