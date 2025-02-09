class EventModel {
  final String content;
  final DateTime date;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      content: json["content"],
      date: DateTime.parse((json['date'] as String)),
    );
  }

  EventModel({
    required this.content,
    required this.date,
  });
}
