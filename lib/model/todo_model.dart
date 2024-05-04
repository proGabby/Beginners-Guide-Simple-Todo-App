class TodoModel {
  final String id;
  final String title;
  final DateTime creationDate;
  final DateTime scheduleDate;
  final String description;
  final String eventType;
  bool isDone;

  TodoModel(
      {required this.id,
      required this.title,
      required this.creationDate,
      required this.scheduleDate,
      required this.description,
      required this.eventType,
      required this.isDone});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'creationDate': creationDate.toIso8601String(),
      'scheduleDate': scheduleDate.toIso8601String(),
      'description': description,
      'eventType': eventType,
    };
  }

  // factory TodoModel.fromJson(Map<String, dynamic> json) {
  //   return TodoModel(
  //       title: json['title'],
  //       creationDate: DateTime.parse(json['creationDate']),
  //       scheduleDate: DateTime.parse(json['scheduleDate']),
  //       description: json['description'],
  //       eventType: json['eventType'],
  //       isDone: json['isDone']);
  // }
}
