import 'package:get/get.dart';

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
    String originalText = text;
    text = text.toLowerCase();
    String locale = Get.locale?.languageCode ?? 'en';

    DateTime now = DateTime.now();
    DateTime taskTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0);

    int duration = 60;
    String priority = "MEDIUM";

    // 1. Parse Priority (Multilingual)
    final priorityHigh = RegExp(r'\b(urgent|important|high|asap|critical|alta|urgente|importante|عالية|عاجل|هام|hoch|dringend|wichtig|haute|urgent)\b');
    final priorityLow = RegExp(r'\b(low|minor|not important|easy|baja|menor|poco importante|fácil|منخفضة|بسيط|غير هام|سهل|niedrig|unwichtig|basse|mineure|pas important)\b');
    
    if (priorityHigh.hasMatch(text)) {
      priority = "HIGH";
    } else if (priorityLow.hasMatch(text)) {
      priority = "LOW";
    }

    // 2. Parse Duration (Multilingual)
    final durationMatch = RegExp(r'(\d+)\s*(min|minute|hour|hr|hora|ساعة|دقيقة|stunde|heure)s?').firstMatch(text);
    if (durationMatch != null) {
      int val = int.parse(durationMatch.group(1)!);
      String unit = durationMatch.group(2)!;
      if (unit.contains('hour') || unit.contains('hr') || unit.contains('hora') || unit.contains('ساعة') || unit.contains('stunde') || unit.contains('heure')) {
        duration = val * 60;
      } else {
        duration = val;
      }
    }

    // 3. Parse Date (Multilingual)
    if (text.contains("tomorrow") || text.contains("mañana") || text.contains("غدا") || text.contains("morgen") || text.contains("demain")) {
      taskTime = DateTime(now.year, now.month, now.day + 1, taskTime.hour, taskTime.minute);
    } else if (text.contains("today") || text.contains("hoy") || text.contains("اليوم") || text.contains("heute") || text.contains("aujourd'hui")) {
      taskTime = DateTime(now.year, now.month, now.day, taskTime.hour, taskTime.minute);
    }

    // 4. Parse Time (Improved Regex)
    // Supports 10:00, 10am, 10 a.m., 10:00 p.m.
    final timeMatch = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*([ap]\.?m\.?)?').firstMatch(text);
    if (timeMatch != null) {
      int hour = int.parse(timeMatch.group(1)!);
      int minute = timeMatch.group(2) != null ? int.parse(timeMatch.group(2)!) : 0;
      String? ampm = timeMatch.group(3)?.replaceAll('.', '').toLowerCase();

      if (ampm == "pm" && hour < 12) hour += 12;
      if (ampm == "am" && hour == 12) hour = 0;
      
      if (ampm == null && hour < 12 && hour > 0) {
        if (hour < 8) hour += 12; 
      }

      taskTime = DateTime(taskTime.year, taskTime.month, taskTime.day, hour, minute);
    }

    // 5. Clean Title (Multilingual & Improved)
    String title = originalText;
    List<String> toRemove = [
      // Priority
      r"\b(urgent|important|high|asap|critical|alta|urgente|importante|عالية|عاجل|هام|hoch|dringend|wichtig|haute|urgent)\b",
      // Date
      r"\b(today|tomorrow|day after tomorrow|hoy|mañana|pasado mañana|اليوم|غدا|بعد غد|heute|morgen|übermorgen|aujourd'hui|demain|après-demain)\b",
      // Duration
      r"\d+\s*(min|minute|hour|hr|hora|ساعة|دقيقة|stunde|heure)s?",
      // Time (including standalone am/pm)
      r"at \d{1,2}(?::\d{2})?\s*([ap]\.?m\.?)?",
      r"\d{1,2}(?::\d{2})?\s*([ap]\.?m\.?)",
      r"\b([ap]\.?m\.?)\b",
      // Common prefixes/articles/conjunctions
      r"\b(add|set|create|task|a|an|the|and|añadir|crear|tarea|un|una|el|la|y|أضف|إنشاء|مهمة|ال|و|hinzufügen|erstellen|aufgabe|ein|eine|der|die|das|und|ajouter|créer|tâche|un|une|le|la|et)\b",

      // Prepositions
      r"\b(on|at|for|en|a|para|في|ب|على|am|um|für|sur|pour|dans)\b",
      // Relative times
      r"\b(morning|afternoon|evening|night|mañana|tarde|noche|صباح|ظهيرة|مساء|ليل|morgen|nachmittag|abend|nacht|matin|après-midi|soir|nuit)\b",
    ];


    for (var pattern in toRemove) {
      title = title.replaceAll(RegExp(pattern, caseSensitive: false), "");
    }

    // Final cleanup of extra spaces and punctuation
    title = title.replaceAll(RegExp(r'\s+'), " ").replaceAll(RegExp(r'^[^\w\u0600-\u06FF]+|[^\w\u0600-\u06FF]+$'), "").trim();
    
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    } else {
      title = "New Task";
    }

    return ParsedTask(
      title: title,
      dateTime: taskTime,
      duration: duration,
      priority: priority,
    );
  }
}


