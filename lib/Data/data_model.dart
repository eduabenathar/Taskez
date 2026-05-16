import 'package:flutter/material.dart';
import 'package:taskez/Values/values.dart';

class AppData {
  static final List<Map<String, dynamic>> progressIndicatorList = [
    {
      "cardTitle": "Progress Task Progress",
      "rating": "3/5",
      "progress": "68.99",
      "progressBar": "2"
    },
    {
      "cardTitle": "Registration",
      "rating": "3/4",
      "progress": "75.00",
      "progressBar": "3"
    },
    {
      "cardTitle": "Invite 5 Members",
      "rating": "2/5",
      "progress": "50",
      "progressBar": "1"
    },
    {
      "cardTitle": "Setup Profile",
      "rating": "3/4",
      "progress": "75",
      "progressBar": "3"
    },
    {
      "cardTitle": "Complete Workspace",
      "rating": "3/5",
      "progress": "68.99",
      "progressBar": "2"
    },
  ];

  static final List<Map<String, dynamic>> notificationMentions = [
    {
      "mentionedBy": "Benjamin Poole",
      "mentionedIn": "Unity Gaming",
      "read": false,
      "date": "Nov 2nd",
      "profileImage": "assets/memoji/1.png",
      "hashTagPresent": true,
      "userOnline": false,
      "color": "BBF1C3",
      "hashElement": "@tranmautritam",
      "message":
          " when you have time please take a look at the new designs I just made in Figma. 👋"
    },
    {
      "mentionedBy": "Katharine Walls",
      "mentionedIn": "Unity Gaming",
      "read": true,
      "date": "Nov 2nd",
      "profileImage": "assets/memoji/2.png",
      "hashTagPresent": false,
      "color": "DBCFFE",
      "userOnline": true,
      "hashElement": "",
      "message":
          "Please make the presentation as soon as possible Tam. We're still waiting for it. 🏀"
    },
    {
      "mentionedBy": "Bertha Ramos",
      "mentionedIn": "UI8 Products",
      "read": true,
      "date": "Nov 2nd",
      "profileImage": "assets/memoji/4.png",
      "hashTagPresent": false,
      "userOnline": true,
      "color": "FFC5D5",
      "hashElement": "",
      "message":
          "Are you actually working? I don't see any new stuffs from you. Please Be creative!!!"
    },
    {
      "mentionedBy": "Marie Bowen",
      "mentionedIn": "Productivity",
      "date": "Nov 2nd",
      "read": true,
      "profileImage": "assets/memoji/7.png",
      "hashTagPresent": false,
      "color": "FAA3FF",
      "userOnline": false,
      "hashElement": "",
      "message": "Are you actually working? We're still waiting for it. 🏀"
    },
    {
      "mentionedBy": "Katharine Walls",
      "mentionedIn": "Unity Gaming",
      "read": true,
      "date": "Nov 2nd",
      "profileImage": "assets/memoji/2.png",
      "hashTagPresent": false,
      "color": "DBCFFE",
      "userOnline": true,
      "hashElement": "",
      "message":
          "Please make the presentation as soon as possible Tam. We're still waiting for it. 🏀"
    },
    {
      "mentionedBy": "Bertha Ramos",
      "mentionedIn": "UI8 Products",
      "read": true,
      "date": "Nov 2nd",
      "profileImage": "assets/memoji/4.png",
      "hashTagPresent": false,
      "userOnline": true,
      "color": "FFC5D5",
      "hashElement": "",
      "message":
          "Are you actually working? I don't see any new stuffs from you. Please Be creative!!!"
    },
    {
      "mentionedBy": "Marie Bowen",
      "mentionedIn": "Productivity",
      "date": "Nov 2nd",
      "read": true,
      "profileImage": "assets/memoji/7.png",
      "hashTagPresent": false,
      "color": "FAA3FF",
      "userOnline": false,
      "hashElement": "",
      "message": "Are you actually working? We're still waiting for it. 🏀"
    },
  ];

  static final List<String> profileImages = [
    "assets/memoji/1.png",
    "assets/memoji/2.png",
    "assets/memoji/4.png",
    "assets/memoji/7.png"
  ];

  static final List<Color> groupBackgroundColors = [
    HexColor.fromHex("BCF2C7"),
    HexColor.fromHex("8D96FF"),
    HexColor.fromHex("A5F69C"),
    HexColor.fromHex("FCA3FF")
  ];

  static final List<Map<String, dynamic>> onlineUsers = [
    {
      "name": "Gareth Reid 🔥",
      "profileImage": "assets/memoji/1.png",
      "color": "BAF0C5",
    },
    {
      "name": "Vincent Lyons 🇺🇸",
      "profileImage": "assets/memoji/2.png",
      "color": "DACFFE",
    },
    {
      "name": "Adeline Nunez 🎉",
      "profileImage": "assets/memoji/4.png",
      "color": "FFC7D5",
    },
    {
      "name": "Samuel Doyle 🔥",
      "profileImage": "assets/memoji/7.png",
      "color": "C0E7FD",
    },
    {
      "name": "Ruth Benson 🔥",
      "profileImage": "assets/memoji/9.png",
      "color": "D7D2D4",
    },
    {
      "name": "Adeline Nunez 🎉",
      "profileImage": "assets/memoji/4.png",
      "color": "FFC7D5",
    },
    {
      "name": "Samuel Doyle 🔥",
      "profileImage": "assets/memoji/7.png",
      "color": "C0E7FD",
    },
    {
      "name": "Ruth Benson 🔥",
      "profileImage": "assets/memoji/9.png",
      "color": "D7D2D4",
    },
    {
      "name": "Adeline Nunez 🎉",
      "profileImage": "assets/memoji/4.png",
      "color": "FFC7D5",
    },
    {
      "name": "Samuel Doyle 🔥",
      "profileImage": "assets/memoji/7.png",
      "color": "C0E7FD",
    },
    {
      "name": "Ruth Benson 🔥",
      "profileImage": "assets/memoji/9.png",
      "color": "D7D2D4",
    },
    {
      "name": "Gareth Reid 🔥",
      "profileImage": "assets/memoji/1.png",
      "color": "BAF0C5",
    },
    {
      "name": "Vincent Lyons 🇺🇸",
      "profileImage": "assets/memoji/2.png",
      "color": "DACFFE",
    },
    {
      "name": "Adeline Nunez 🎉",
      "profileImage": "assets/memoji/4.png",
      "color": "FFC7D5",
    },
  ];

  static final List<Map<String, dynamic>> employeeData = [
    {
      "employeeName": "Aaliyah Langosh",
      "employeeImage": "assets/girl_smile.png",
      "color": HexColor.fromHex("FCA3FF"),
      "activated": true,
      "employeePosition": "Senior Interactions Agent"
    },
    {
      "employeeName": "Greta Streich",
      "employeeImage": "assets/man-head.png",
      "color": HexColor.fromHex("94F1F1"),
      "activated": false,
      "employeePosition": "Dynamic Security Technician"
    },
    {
      "employeeName": "Judd Koch",
      "employeeImage": "assets/memoji/7.png",
      "color": HexColor.fromHex("8D96FF"),
      "activated": true,
      "employeePosition": "Senior Interactions Agent"
    },
    {
      "employeeName": "Katherine Wells",
      "employeeImage": "assets/memoji/2.png",
      "color": HexColor.fromHex("DBD0FD"),
      "activated": false,
      "employeePosition": "Dynamic Security Technician"
    },
    {
      "employeeName": "Betha Ramos",
      "employeeImage": "assets/memoji/9.png",
      "color": HexColor.fromHex("FFC5D5"),
      "activated": false,
      "employeePosition": "Dynamic Security Technician"
    },
    {
      "employeeName": "Greta Streich",
      "employeeImage": "assets/girl_smile.png",
      "color": HexColor.fromHex("94F1F1"),
      "activated": false,
      "employeePosition": "Dynamic Security Technician"
    },
    {
      "employeeName": "Aaliyah Langosh",
      "employeeImage": "assets/girl_smile.png",
      "color": HexColor.fromHex("FCA3FF"),
      "activated": true,
      "employeePosition": "Senior Interactions Agent"
    },
  ];

  static final List<Map<String, dynamic>> productData = [
    {
      "projectName": "Unity Dashboard",
      "category": "Design",
      "color": "A06AFA",
      "ratingsUpperNumber": 15,
      "ratingsLowerNumber": 20
    },
    {
      "projectName": "Instagram   Shots🇺🇸",
      "category": "Marketing",
      "color": "8D96FF",
      "ratingsUpperNumber": 8,
      "ratingsLowerNumber": 20
    },
    {
      "projectName": "Cubbies",
      "category": "Design",
      "color": "FF968E",
      "ratingsUpperNumber": 15,
      "ratingsLowerNumber": 20
    },
    {
      "projectName": "OpenMind 🚀",
      "category": "Development",
      "color": "FFDE72",
      "ratingsUpperNumber": 19,
      "ratingsLowerNumber": 20
    },
    {
      "projectName": "UI8 Platform",
      "category": "Design",
      "color": "A06AFA",
      "ratingsUpperNumber": 10,
      "ratingsLowerNumber": 20
    },
    {
      "projectName": "3D Characters Inc.",
      "category": "Development",
      "color": "A6F69C",
      "ratingsUpperNumber": 18,
      "ratingsLowerNumber": 20
    },
  ];
}

enum TaskPriority { high, medium, low }

enum AttachmentKind { image, doc, video }

enum TaskIcon {
  briefcase,
  design,
  code,
  chat,
  rocket,
  bulb,
  campaign,
  research,
  finance,
  star,
}

IconData taskIconData(TaskIcon icon) {
  switch (icon) {
    case TaskIcon.briefcase:
      return Icons.work_outline_rounded;
    case TaskIcon.design:
      return Icons.palette_outlined;
    case TaskIcon.code:
      return Icons.code_rounded;
    case TaskIcon.chat:
      return Icons.forum_outlined;
    case TaskIcon.rocket:
      return Icons.rocket_launch_outlined;
    case TaskIcon.bulb:
      return Icons.lightbulb_outline_rounded;
    case TaskIcon.campaign:
      return Icons.campaign_outlined;
    case TaskIcon.research:
      return Icons.science_outlined;
    case TaskIcon.finance:
      return Icons.account_balance_wallet_outlined;
    case TaskIcon.star:
      return Icons.star_outline_rounded;
  }
}

class Subtask {
  final String id;
  final String title;
  final bool done;

  const Subtask({required this.id, required this.title, this.done = false});

  Subtask copyWith({String? title, bool? done}) =>
      Subtask(id: id, title: title ?? this.title, done: done ?? this.done);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        id: json['id'] as String,
        title: json['title'] as String,
        done: (json['done'] as bool?) ?? false,
      );
}

class TaskComment {
  final String id;
  final String author;
  final String message;
  final DateTime createdAt;
  final List<Attachment> attachments;

  const TaskComment({
    required this.id,
    required this.author,
    required this.message,
    required this.createdAt,
    this.attachments = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'message': message,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'attachments': attachments.map((a) => a.toJson()).toList(),
      };

  factory TaskComment.fromJson(Map<String, dynamic> json) => TaskComment(
        id: json['id'] as String,
        author: (json['author'] as String?) ?? 'You',
        message: json['message'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['createdAt'] as int,
        ),
        attachments: ((json['attachments'] as List?) ?? const [])
            .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class SubtaskGroup {
  final String id;
  final String title;
  final List<Subtask> subtasks;
  final int commentsCount;
  final List<TaskComment> comments;
  final bool expanded;

  const SubtaskGroup({
    required this.id,
    required this.title,
    this.subtasks = const [],
    this.commentsCount = 0,
    this.comments = const [],
    this.expanded = true,
  });

  int get effectiveCommentsCount {
    // ignore: unnecessary_null_comparison
    final len = comments == null ? 0 : comments.length;
    return commentsCount > len ? commentsCount : len;
  }

  SubtaskGroup copyWith({
    String? title,
    List<Subtask>? subtasks,
    int? commentsCount,
    List<TaskComment>? comments,
    bool? expanded,
  }) =>
      SubtaskGroup(
        id: id,
        title: title ?? this.title,
        subtasks: subtasks ?? this.subtasks,
        commentsCount: commentsCount ?? this.commentsCount,
        comments: comments ?? this.comments,
        expanded: expanded ?? this.expanded,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'commentsCount': commentsCount,
        'comments': comments.map((c) => c.toJson()).toList(),
        'expanded': expanded,
      };

  factory SubtaskGroup.fromJson(Map<String, dynamic> json) => SubtaskGroup(
        id: json['id'] as String,
        title: json['title'] as String,
        subtasks: ((json['subtasks'] as List?) ?? const [])
            .map((e) => Subtask.fromJson(e as Map<String, dynamic>))
            .toList(),
        commentsCount: (json['commentsCount'] as int?) ?? 0,
        comments: ((json['comments'] as List?) ?? const [])
            .map((e) => TaskComment.fromJson(e as Map<String, dynamic>))
            .toList(),
        expanded: (json['expanded'] as bool?) ?? true,
      );
}

class Attachment {
  final String name;
  final String sizeLabel;
  final AttachmentKind kind;
  final String? localPath;

  const Attachment({
    required this.name,
    required this.sizeLabel,
    required this.kind,
    this.localPath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sizeLabel': sizeLabel,
        'kind': kind.name,
        'localPath': localPath,
      };

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        name: json['name'] as String,
        sizeLabel: json['sizeLabel'] as String,
        kind: AttachmentKind.values.firstWhere(
          (k) => k.name == (json['kind'] as String?),
          orElse: () => AttachmentKind.doc,
        ),
        localPath: json['localPath'] as String?,
      );
}

class EvidenceCategory {
  final String id;
  final String name;
  final List<Attachment> items;

  const EvidenceCategory({
    required this.id,
    required this.name,
    this.items = const [],
  });

  EvidenceCategory copyWith({String? name, List<Attachment>? items}) =>
      EvidenceCategory(
        id: id,
        name: name ?? this.name,
        items: items ?? this.items,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((a) => a.toJson()).toList(),
      };

  factory EvidenceCategory.fromJson(Map<String, dynamic> json) =>
      EvidenceCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        items: ((json['items'] as List?) ?? const [])
            .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class CalendarEventData {
  final String id;
  final DateTime date;
  final int startMinutes;
  final int durationMinutes;
  final String title;
  final String location;
  final Color backgroundColor;
  final Color accentColor;
  final List<String> attendeeImages;
  final String? description;
  final TaskPriority priority;
  final DateTime? startDate;
  final DateTime? dueDate;
  final double progress;
  final List<Attachment> attachments;
  final List<SubtaskGroup> subtaskGroups;
  final List<EvidenceCategory> photoReport;
  final TaskIcon icon;

  const CalendarEventData({
    required this.id,
    required this.date,
    required this.startMinutes,
    required this.durationMinutes,
    required this.title,
    required this.location,
    required this.backgroundColor,
    required this.accentColor,
    required this.attendeeImages,
    this.description,
    this.priority = TaskPriority.medium,
    this.startDate,
    this.dueDate,
    this.progress = 0,
    this.attachments = const [],
    this.subtaskGroups = const [],
    this.photoReport = const [],
    this.icon = TaskIcon.briefcase,
  });

  int get endMinutes => startMinutes + durationMinutes;

  String get timeLabel {
    return "${_formatClock(startMinutes)}  -  ${_formatClock(endMinutes)}";
  }

  static String _formatClock(int minutes) {
    final h24 = (minutes ~/ 60) % 24;
    final m = minutes % 60;
    final period = h24 >= 12 ? "PM" : "AM";
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final hh = h12.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    return "$hh:$mm $period";
  }

  CalendarEventData copyWith({
    DateTime? date,
    int? startMinutes,
    int? durationMinutes,
    String? title,
    String? location,
    Color? backgroundColor,
    Color? accentColor,
    List<String>? attendeeImages,
    String? description,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? dueDate,
    double? progress,
    List<Attachment>? attachments,
    List<SubtaskGroup>? subtaskGroups,
    List<EvidenceCategory>? photoReport,
    TaskIcon? icon,
  }) {
    return CalendarEventData(
      id: id,
      date: date ?? this.date,
      startMinutes: startMinutes ?? this.startMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      title: title ?? this.title,
      location: location ?? this.location,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      attendeeImages: attendeeImages ?? this.attendeeImages,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      attachments: attachments ?? this.attachments,
      subtaskGroups: subtaskGroups ?? this.subtaskGroups,
      photoReport: photoReport ?? this.photoReport,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': DateUtils.dateOnly(date).millisecondsSinceEpoch,
        'startMinutes': startMinutes,
        'durationMinutes': durationMinutes,
        'title': title,
        'location': location,
        'backgroundColor': backgroundColor.toARGB32(),
        'accentColor': accentColor.toARGB32(),
        'attendeeImages': attendeeImages,
        'description': description,
        'priority': priority.name,
        'startDate': startDate?.millisecondsSinceEpoch,
        'dueDate': dueDate?.millisecondsSinceEpoch,
        'progress': progress,
        'attachments': attachments.map((a) => a.toJson()).toList(),
        'subtaskGroups': subtaskGroups.map((g) => g.toJson()).toList(),
        'photoReport': photoReport.map((c) => c.toJson()).toList(),
        'icon': icon.name,
      };

  factory CalendarEventData.fromJson(Map<String, dynamic> json) {
    return CalendarEventData(
      id: json['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      startMinutes: json['startMinutes'] as int,
      durationMinutes: json['durationMinutes'] as int,
      title: json['title'] as String,
      location: json['location'] as String,
      backgroundColor: Color(json['backgroundColor'] as int),
      accentColor: Color(json['accentColor'] as int),
      attendeeImages: (json['attendeeImages'] as List).cast<String>(),
      description: json['description'] as String?,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == (json['priority'] as String?),
        orElse: () => TaskPriority.medium,
      ),
      startDate: json['startDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['dueDate'] as int),
      progress: ((json['progress'] as num?) ?? 0).toDouble(),
      attachments: ((json['attachments'] as List?) ?? const [])
          .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtaskGroups: ((json['subtaskGroups'] as List?) ?? const [])
          .map((e) => SubtaskGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      photoReport: ((json['photoReport'] as List?) ?? const [])
          .map((e) => EvidenceCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: TaskIcon.values.firstWhere(
        (i) => i.name == (json['icon'] as String?),
        orElse: () => TaskIcon.briefcase,
      ),
    );
  }
}
