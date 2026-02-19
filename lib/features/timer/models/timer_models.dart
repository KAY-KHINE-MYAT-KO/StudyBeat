class TimerTopic {
  final int id;
  final String name;
  bool selected;

  TimerTopic({required this.id, required this.name, this.selected = false});
}

class ExamGroup {
  final int id;
  final String name;
  final List<TimerTopic> topics;
  bool expanded;

  ExamGroup({required this.id, required this.name, required this.topics, this.expanded = false});
}
