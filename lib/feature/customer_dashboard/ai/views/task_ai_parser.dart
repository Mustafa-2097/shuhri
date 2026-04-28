class ParsedTask {
  String title;
  DateTime dateTime;
  int duration;
  String priority;

  ParsedTask({
    required this.title,
    required this.dateTime,
    required this.duration,
    required this.priority,
  });
}

class TaskAIParser {
  static ParsedTask parse(String text) {
    text = text.toLowerCase();

    DateTime now = DateTime.now();
    DateTime taskTime = now.add(Duration(hours: 1));

    int duration = 60;
    String priority = "MEDIUM";
    String title = text;

    if (text.contains("tomorrow")) {
      taskTime = now.add(Duration(days: 1));
    }

    if (text.contains("urgent") ||
        text.contains("important") ||
        text.contains("asap")) {
      priority = "HIGH";
    }

    if (text.contains("30 min")) duration = 30;
    if (text.contains("2 hour")) duration = 120;

    RegExp timeRegex = RegExp(r'(\d{1,2}) ?(am|pm)');
    final match = timeRegex.firstMatch(text);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      String ampm = match.group(2)!;

      if (ampm == "pm" && hour < 12) hour += 12;

      taskTime = DateTime(taskTime.year, taskTime.month, taskTime.day, hour);
    }

    title = title
        .replaceAll("tomorrow", "")
        .replaceAll("urgent", "")
        .replaceAll(RegExp(r'\d{1,2} ?(am|pm)'), "")
        .trim();

    return ParsedTask(
      title: title,
      dateTime: taskTime,
      duration: duration,
      priority: priority,
    );
  }
}
