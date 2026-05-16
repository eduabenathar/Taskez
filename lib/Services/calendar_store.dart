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

  static const String _prefsKey = 'calendar.events.v6';
  static const String _seedKey = 'calendar.seeded.v6';

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

  CalendarEventData? eventById(String id) {
    for (final event in events.value) {
      if (event.id == id) return event;
    }
    return null;
  }

  Future<void> add(CalendarEventData event) async {
    events.value = [...events.value, event];
    await _persist();
  }

  Future<void> update(CalendarEventData event) async {
    var replaced = false;
    final next = <CalendarEventData>[];
    for (final e in events.value) {
      if (e.id == event.id) {
        next.add(event);
        replaced = true;
      } else {
        next.add(e);
      }
    }
    events.value = replaced ? next : [...next, event];
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
        icon: TaskIcon.research,
        location: "Online  -  Zoom meeting",
        backgroundColor: const Color(0xFFD7F4E5),
        accentColor: const Color(0xFF1E9D6F),
        attendeeImages: const [
          "assets/memoji/2.png",
          "assets/memoji/7.png",
          "assets/memoji/9.png",
        ],
        description:
            "Map user needs, review feedback from support, and prepare the first design recommendations for the new feature experience.",
        priority: TaskPriority.medium,
        startDate: DateTime(today.year, today.month, today.day)
            .subtract(const Duration(days: 4)),
        dueDate: DateTime(today.year, today.month, today.day)
            .add(const Duration(days: 2)),
        attachments: const [
          Attachment(
            name: "research-notes.pdf",
            sizeLabel: "4.1 MB",
            kind: AttachmentKind.doc,
          ),
          Attachment(
            name: "user-interview-clips.mp4",
            sizeLabel: "38 MB",
            kind: AttachmentKind.video,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "research-g1",
            title: "Task 1 - Discovery",
            commentsCount: 3,
            comments: [
              TaskComment(
                id: newId(),
                author: "Marie Bowen",
                message:
                    "I grouped the main pain points from yesterday's interview.",
                createdAt: today.subtract(const Duration(hours: 5)),
              ),
            ],
            subtasks: const [
              Subtask(id: "research-s1", title: "Review user feedback inbox"),
              Subtask(id: "research-s2", title: "Prepare interview summary"),
              Subtask(id: "research-s3", title: "Define research assumptions"),
            ],
          ),
          SubtaskGroup(
            id: "research-g2",
            title: "Task 2 - Feature Direction",
            commentsCount: 1,
            comments: [
              TaskComment(
                id: "research-c2",
                author: "Benjamin Poole",
                message: "Adding the competitor screenshots here for review.",
                createdAt: today.subtract(const Duration(hours: 2)),
                attachments: const [
                  Attachment(
                    name: "competitor-screens.png",
                    sizeLabel: "1.8 MB",
                    kind: AttachmentKind.image,
                  ),
                ],
              ),
            ],
            subtasks: const [
              Subtask(
                  id: "research-s4", title: "Collect competitor references"),
              Subtask(id: "research-s5", title: "Write opportunity statement"),
            ],
          ),
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 11 * 60,
        durationMinutes: 60,
        title: "Wireframing & Initial UI Design Finance",
        icon: TaskIcon.design,
        location: "WFH  -  Daily task",
        backgroundColor: const Color(0xFFFCEAC8),
        accentColor: const Color(0xFFB37A1A),
        attendeeImages: const [
          "assets/memoji/4.png",
          "assets/memoji/7.png",
          "assets/memoji/1.png",
        ],
        description:
            "Create the first finance wireframes, align navigation structure, and prepare the UI direction for dashboard flows.",
        priority: TaskPriority.medium,
        startDate: DateTime(today.year, today.month, today.day)
            .subtract(const Duration(days: 7)),
        dueDate: DateTime(today.year, today.month, today.day)
            .add(const Duration(days: 3)),
        attachments: const [
          Attachment(
            name: "finance-wireframes.fig",
            sizeLabel: "9.4 MB",
            kind: AttachmentKind.doc,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "wire-g1",
            title: "Task 1 - Structure",
            commentsCount: 2,
            comments: [
              TaskComment(
                id: "wire-c1",
                author: "Katharine Walls",
                message: "The daily task flow looks clearer with two steps.",
                createdAt: today.subtract(const Duration(hours: 7)),
              ),
            ],
            subtasks: const [
              Subtask(
                  id: "wire-s1",
                  title: "Outline dashboard information hierarchy"),
              Subtask(id: "wire-s2", title: "Draft primary navigation states"),
              Subtask(id: "wire-s3", title: "Create empty state wireframes"),
            ],
          ),
          SubtaskGroup(
            id: "wire-g2",
            title: "Task 2 - UI Draft",
            commentsCount: 2,
            subtasks: const [
              Subtask(id: "wire-s4", title: "Design transaction card layout"),
              Subtask(id: "wire-s5", title: "Prepare finance summary module"),
            ],
          ),
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: today,
        startMinutes: 12 * 60 + 30,
        durationMinutes: 60,
        title: "Discuss & Feedback Wireframing UI Design Finance",
        icon: TaskIcon.chat,
        location: "WFH  -  Daily task",
        backgroundColor: const Color(0xFFF7DDF1),
        accentColor: const Color(0xFFB54AA0),
        attendeeImages: const [
          "assets/memoji/9.png",
          "assets/memoji/2.png",
          "assets/memoji/4.png",
        ],
        description:
            "Review the initial wireframes with the team, record open questions, and convert feedback into design follow-up tasks.",
        priority: TaskPriority.low,
        startDate: DateTime(today.year, today.month, today.day)
            .subtract(const Duration(days: 2)),
        dueDate: DateTime(today.year, today.month, today.day)
            .add(const Duration(days: 4)),
        attachments: const [
          Attachment(
            name: "wireframe-review.pdf",
            sizeLabel: "6.2 MB",
            kind: AttachmentKind.doc,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "feedback-g1",
            title: "Task 1 - Design Review",
            commentsCount: 5,
            comments: [
              TaskComment(
                id: "feedback-c1",
                author: "Marie Bowen",
                message: "I attached the review board with the open remarks.",
                createdAt: today.subtract(const Duration(hours: 1)),
                attachments: const [
                  Attachment(
                    name: "review-board.png",
                    sizeLabel: "2.2 MB",
                    kind: AttachmentKind.image,
                  ),
                ],
              ),
            ],
            subtasks: const [
              Subtask(
                  id: "feedback-s1",
                  title: "Share prototype with finance team"),
              Subtask(id: "feedback-s2", title: "Capture navigation feedback"),
              Subtask(id: "feedback-s3", title: "Prioritize UI changes"),
            ],
          ),
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: tomorrow,
        startMinutes: 14 * 60,
        durationMinutes: 60,
        title: "Sprint Planning",
        icon: TaskIcon.rocket,
        location: "Online  -  Zoom meeting",
        backgroundColor: const Color(0xFFE8E0FF),
        accentColor: const Color(0xFF6752D8),
        attendeeImages: const [
          "assets/memoji/1.png",
          "assets/memoji/4.png",
        ],
        description:
            "Plan the next sprint, validate capacity, and assign delivery owners for design and implementation work.",
        priority: TaskPriority.high,
        startDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
            .subtract(const Duration(days: 1)),
        dueDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
            .add(const Duration(days: 1)),
        attachments: const [
          Attachment(
            name: "sprint-backlog.xlsx",
            sizeLabel: "1.1 MB",
            kind: AttachmentKind.doc,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "sprint-g1",
            title: "Task 1 - Planning",
            commentsCount: 4,
            comments: [
              TaskComment(
                id: "sprint-c1",
                author: "Benjamin Poole",
                message: "Capacity is updated with the latest holidays.",
                createdAt: today.subtract(const Duration(hours: 8)),
              ),
            ],
            subtasks: const [
              Subtask(
                  id: "sprint-s1",
                  title: "Review backlog readiness",
                  done: true),
              Subtask(id: "sprint-s2", title: "Confirm sprint capacity"),
              Subtask(id: "sprint-s3", title: "Assign task owners"),
            ],
          ),
        ],
      ),
      CalendarEventData(
        id: newId(),
        date: yesterday,
        startMinutes: 15 * 60,
        durationMinutes: 60,
        title: "Design Critique",
        icon: TaskIcon.star,
        location: "Office  -  Studio room",
        backgroundColor: const Color(0xFFD7F4E5),
        accentColor: const Color(0xFF1E9D6F),
        attendeeImages: const [
          "assets/memoji/7.png",
          "assets/memoji/2.png",
        ],
        description:
            "Evaluate the latest visual direction, decide which screens need iteration, and document action items for the team.",
        priority: TaskPriority.low,
        startDate: DateTime(yesterday.year, yesterday.month, yesterday.day)
            .subtract(const Duration(days: 3)),
        dueDate: DateTime(yesterday.year, yesterday.month, yesterday.day),
        progress: 1,
        attachments: const [
          Attachment(
            name: "critique-notes.pdf",
            sizeLabel: "3.6 MB",
            kind: AttachmentKind.doc,
          ),
          Attachment(
            name: "visual-direction.png",
            sizeLabel: "2.7 MB",
            kind: AttachmentKind.image,
          ),
        ],
        subtaskGroups: [
          SubtaskGroup(
            id: "critique-g1",
            title: "Task 1 - Critique",
            commentsCount: 6,
            comments: [
              TaskComment(
                id: "critique-c1",
                author: "Katharine Walls",
                message: "The action list is ready for the next design pass.",
                createdAt: yesterday.add(const Duration(hours: 2)),
              ),
            ],
            subtasks: const [
              Subtask(
                  id: "critique-s1",
                  title: "Review dashboard direction",
                  done: true),
              Subtask(
                  id: "critique-s2",
                  title: "Validate card hierarchy",
                  done: true),
              Subtask(
                  id: "critique-s3",
                  title: "Document final decisions",
                  done: true),
            ],
          ),
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
