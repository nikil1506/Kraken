class JournalModel {
  final String emote;
  final String title;
  final String content;
  final DateTime date;

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      date: DateTime.parse((json['date'] as String)),
      content: json["content"],
      emote: json["emoji"],
      title: json["title"],
    );
  }

  JournalModel({
    required this.emote,
    required this.title,
    required this.content,
    required this.date,
  });
}
