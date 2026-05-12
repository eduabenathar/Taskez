import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskez/Data/data_model.dart';

/// Persistent event store backed by [SharedPreferences].
///
/// Seeds the storage with a sample week the first time the app starts so the
/// calendar is never empty for a fresh install.
class CalendarStore {
  CalendarStore._();
  static final CalendarStore instance = CalendarStore._();

  static const String _prefsKey = 'calendar.events.v4';
  static const String _seedKey = 'calendar.seeded.v4';

  final ValueNotifier<List<CalendarEventData>> events =
      ValueNotifier<List<CalendarEventData>>(<CalendarEventData>[]);

  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    final seeded = _prefs!.getBool(_seedKey) ?? false;
    if (!seeded) {
      events.value = _seedEvents();
      await _persist();
      await _prefs!.setBool(_seedKey, true);
    } else {
      events.value = _load();
    }
    _initialized = true;
  }

  List<CalendarEventData> _load() {
    final raw = _prefs!.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return <CalendarEventData>[];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CalendarEventData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _persist() async {
    final raw = jsonEncode(events.value.map((e) => e.toJson()).toList());
    await _prefs!.setString(_prefsKey, raw);
  }

  List<CalendarEventData> eventsForDay(DateTime day) {
    final list = events.value
        .where((e) => DateUtils.isSameDay(e.date, day))
        .toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    return list;
  }

  Future<void> add(CalendarEventData event) async {
    events.value = [...events.value, event];
    await _persist();
  }

  Future<void> update(CalendarEventData event) async {
    events.value = [
      for (final e in events.value)
        if (e.id == event.id) event else e,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    events.value = events.value.where((e) => e.id != id).toList();
    await _persist();
  }

  static String newId() {
    final r = Random();
    return DateTime.now().microsecondsSinceEpoch.toRadixString(36) +
        r.nextInt(1 << 32).toRadixString(36);
  }

  List<CalendarEventData> _seedEvents() {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    return [
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 9 * 60,
        durationMinutes: 60,
        title: "Smart Personal Finance Tracker App",
        icon: TaskIcon.finance,
        location: "Online  -  Zoom meeting",
        backgroundColor: const Color(0xFFE8E0FF),
        accentColor: const Color(0xFF6752D8),
        attendeeImages: const [
          "assets/memoji/1.png",
          "assets/memoji/2.png",
          "assets/memoji/4.png",
          "assets/memoji/7.png",
        ],
        description:
            "Develop and implement core application features, including advanced secure authentication systems, automated expense tracking capabilities, and personalized financial insights to enhance user experience and engagement.",
        priority: TaskPriority.high,
        startDate: DateTime(today.year, today.month, today.day)
            .subtract(const Duration(days: 16)),
        dueDate: DateTime(today.year, today.month, today.day)
            .add(const Duration(days: 1)),
        progress: 0.75,
        attachments: const [
          Attachment(
            name: "UX-userflow-finance.png",
            sizeLabel: "2.5 MB",
            kind: AttachmentKind.image,
          ),
          Attachment(
            name: "Brief-finance-app.pdf",
            sizeLabel: "12.0 MB",
            kind: AttachmentKind.doc,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "g1",
            title: "Task 1 - Research & Planning",
            commentsCount: 8,
            comments: [
              TaskComment(
                id: newId(),
                author: "Benjamin Poole",
                message:
                    "The interview script is ready. I added the open questions for spending habits.",
                createdAt: today.subtract(const Duration(hours: 6)),
              ),
              TaskComment(
                id: newId(),
                author: "Katharine Walls",
                message:
                    "Let's include a question about recurring subscriptions before we close research.",
                createdAt: today.subtract(const Duration(hours: 3)),
              ),
            ],
            subtasks: const [
              Subtask(
                id: "s1",
                title: "Conduct user interviews to understand financial habits",
                done: true,
              ),
              Subtask(
                id: "s2",
                title: "Define key user personas and journey maps",
                done: true,
              ),
              Subtask(
                id: "s3",
                title: "Analyze competitor finance apps for feature gaps",
              ),
            ],
          ),
          SubtaskGroup(
            id: "g2",
            title: "Task 2 – Wireframing & Structure",
            commentsCount: 8,
            comments: [
              TaskComment(
                id: newId(),
                author: "Marie Bowen",
                message:
                    "The dashboard wireframe needs a clearer empty state before handoff.",
                createdAt: today.subtract(const Duration(hours: 4)),
              ),
            ],
            subtasks: const [
              Subtask(
                id: "s4",
                title:
                    "Sketch low-fidelity wireframes for homepage and dashboard",
                done: true,
              ),
              Subtask(
                id: "s5",
                title: "Design task flow for expense tracking and reporting",
              ),
              Subtask(
                id: "s6",
                title:
                    "Build mid-fidelity wireframes in Figma for mobile screens",
              ),
            ],
          ),
          SubtaskGroup(
            id: "g3",
            title: "Task 3 – Visual Design & Prototype",
            commentsCount: 0,
            expanded: false,
            subtasks: const [
              Subtask(id: "s7", title: "Define color palette and typography"),
              Subtask(id: "s8", title: "Build interactive Figma prototype"),
            ],
          ),
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 10 * 60,
        durationMinutes: 60,
        title: "UI/UX Research for New Feature",
        location: "Online  -  Zoom meeting",
        backgroundColor: const Color(0xFFD7F4E5),
        accentColor: const Color(0xFF1E9D6F),
        attendeeImages: const [
          "assets/memoji/2.png",
          "assets/memoji/7.png",
          "assets/memoji/9.png",
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 11 * 60,
        durationMinutes: 60,
        title: "Wireframing & Initial UI Design Finance",
        location: "WFH  -  Daily task",
        backgroundColor: const Color(0xFFFCEAC8),
        accentColor: const Color(0xFFB37A1A),
        attendeeImages: const [
          "assets/memoji/4.png",
          "assets/memoji/7.png",
          "assets/memoji/1.png",
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 12 * 60 + 30,
        durationMinutes: 60,
        title: "Discuss & Feedback Wireframing UI Design Finance",
        location: "WFH  -  Daily task",
        backgroundColor: const Color(0xFFF7DDF1),
        accentColor: const Color(0xFFB54AA0),
        attendeeImages: const [
          "assets/memoji/9.png",
          "assets/memoji/2.png",
          "assets/memoji/4.png",
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: tomorrow,
        startMinutes: 14 * 60,
        durationMinutes: 60,
        title: "Sprint Planning",
        location: "Online  -  Zoom meeting",
        backgroundColor: const Color(0xFFE8E0FF),
        accentColor: const Color(0xFF6752D8),
        attendeeImages: const [
          "assets/memoji/1.png",
          "assets/memoji/4.png",
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: yesterday,
        startMinutes: 15 * 60,
        durationMinutes: 60,
        title: "Design Critique",
        location: "Office  -  Studio room",
        backgroundColor: const Color(0xFFD7F4E5),
        accentColor: const Color(0xFF1E9D6F),
        attendeeImages: const [
          "assets/memoji/7.png",
          "assets/memoji/2.png",
        ],
      ),
    ];
  }
}

/// Color presets available in the event form.
class EventColorPreset {
  final Color background;
  final Color accent;
  const EventColorPreset(this.background, this.accent);

  static const lilac = EventColorPreset(Color(0xFFE8E0FF), Color(0xFF6752D8));
  static const mint = EventColorPreset(Color(0xFFD7F4E5), Color(0xFF1E9D6F));
  static const peach = EventColorPreset(Color(0xFFFCEAC8), Color(0xFFB37A1A));
  static const pink = EventColorPreset(Color(0xFFF7DDF1), Color(0xFFB54AA0));

  static const all = <EventColorPreset>[lilac, mint, peach, pink];
}
