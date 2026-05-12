import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Services/attachment_store.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/attachment_preview.dart';

const _kAccent = Color(0xFF6F5AED);
const _kAccentSoft = Color(0xFFEDEAFE);
const _kGradientTop = Color(0xFFE7E1FA);
const _kGradientBottom = Color(0xFFF5F4F8);
const _kSurface = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE6E5EC);
const _kTextPrimary = Color(0xFF111114);
const _kTextSecondary = Color(0xFF6B6B73);
const _kHighPillBg = Color(0xFFFFE2DC);
const _kHighPillFg = Color(0xFFE26A4D);

class _DetailColors {
  final Color accent;
  final Color accentSoft;
  final Color gradientTop;
  final Color gradientBottom;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color overlaySurface;

  const _DetailColors({
    required this.accent,
    required this.accentSoft,
    required this.gradientTop,
    required this.gradientBottom,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.overlaySurface,
  });

  factory _DetailColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) {
      return const _DetailColors(
        accent: _kAccent,
        accentSoft: _kAccentSoft,
        gradientTop: _kGradientTop,
        gradientBottom: _kGradientBottom,
        surface: _kSurface,
        border: _kBorder,
        textPrimary: _kTextPrimary,
        textSecondary: _kTextSecondary,
        overlaySurface: Color(0xB8FFFFFF),
      );
    }
    return const _DetailColors(
      accent: Color(0xFFA7A2FF),
      accentSoft: Color(0xFF302E66),
      gradientTop: Color(0xFF28233F),
      gradientBottom: Color(0xFF181A1F),
      surface: Color(0xFF242731),
      border: Color(0xFF383B46),
      textPrimary: Color(0xFFF7F7FA),
      textSecondary: Color(0xFFB2B5C0),
      overlaySurface: Color(0xB8242731),
    );
  }
}

const _kPalette = [
  "assets/memoji/1.png",
  "assets/memoji/2.png",
  "assets/memoji/4.png",
  "assets/memoji/7.png",
  "assets/memoji/9.png",
];

enum _AttachmentSource { gallery, camera }

class TaskDetailScreen extends StatefulWidget {
  final CalendarEventData event;

  const TaskDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final ValueNotifier<CalendarEventData> _event;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(widget.event);
  }

  @override
  void dispose() {
    _event.dispose();
    super.dispose();
  }

  void _update(CalendarEventData next) {
    _event.value = next;
    CalendarStore.instance.update(next);
  }

  double _computeProgress(CalendarEventData e) {
    final all = e.subtaskGroups.expand((g) => g.subtasks).toList();
    if (all.isEmpty) return e.progress;
    final done = all.where((s) => s.done).length;
    return done / all.length;
  }

  void _toggleSubtask(String groupId, String subtaskId) {
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        for (final g in e.subtaskGroups)
          if (g.id == groupId)
            g.copyWith(
              subtasks: [
                for (final s in g.subtasks)
                  if (s.id == subtaskId) s.copyWith(done: !s.done) else s,
              ],
            )
          else
            g,
      ],
    ));
  }

  void _toggleGroupExpanded(String groupId) {
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        for (final g in e.subtaskGroups)
          if (g.id == groupId) g.copyWith(expanded: !g.expanded) else g,
      ],
    ));
  }

  void _reorderGroups(int oldIndex, int newIndex) {
    final e = _event.value;
    final groups = [...e.subtaskGroups];
    if (oldIndex < newIndex) newIndex -= 1;
    final moved = groups.removeAt(oldIndex);
    groups.insert(newIndex, moved);
    _update(e.copyWith(subtaskGroups: groups));
  }

  void _reorderSubtasks(String groupId, int oldIndex, int newIndex) {
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        for (final g in e.subtaskGroups)
          if (g.id == groupId)
            g.copyWith(
              subtasks: () {
                final subtasks = [...g.subtasks];
                if (oldIndex < newIndex) newIndex -= 1;
                final moved = subtasks.removeAt(oldIndex);
                subtasks.insert(newIndex, moved);
                return subtasks;
              }(),
            )
          else
            g,
      ],
    ));
  }

  Future<void> _openComments(SubtaskGroup group) async {
    final message = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _CommentsSheet(group: group),
    );
    if (message == null || message.isEmpty) return;
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        for (final g in e.subtaskGroups)
          if (g.id == group.id)
            g.copyWith(
              comments: [
                ...g.comments,
                TaskComment(
                  id: _newId(),
                  author: AppLocalizations.of(context).taskDetailCommentAuthorYou,
                  message: message,
                  createdAt: DateTime.now(),
                ),
              ],
              commentsCount: g.effectiveCommentsCount + 1,
            )
          else
            g,
      ],
    ));
  }

  Future<void> _addSubtask(String groupId) async {
    final l = AppLocalizations.of(context);
    final title = await _promptText(
      context,
      title: l.taskDetailAddSubtask,
      hint: l.taskDetailNewSubtaskHint,
    );
    if (title == null || title.isEmpty) return;
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        for (final g in e.subtaskGroups)
          if (g.id == groupId)
            g.copyWith(
              subtasks: [
                ...g.subtasks,
                Subtask(id: _newId(), title: title),
              ],
              expanded: true,
            )
          else
            g,
      ],
    ));
  }

  Future<void> _addGroup() async {
    final l = AppLocalizations.of(context);
    final title = await _promptText(
      context,
      title: l.taskDetailAddTask,
      hint: l.taskDetailNewGroupHint,
    );
    if (title == null || title.isEmpty) return;
    final e = _event.value;
    _update(e.copyWith(
      subtaskGroups: [
        ...e.subtaskGroups,
        SubtaskGroup(id: _newId(), title: title, expanded: true),
      ],
    ));
  }

  Future<void> _addMember() async {
    final members = _event.value.attendeeImages;
    final available = _kPalette.where((p) => !members.contains(p)).toList();
    if (available.isEmpty) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _MemberPickerSheet(available: available),
    );
    if (picked == null) return;
    _update(_event.value.copyWith(
      attendeeImages: [..._event.value.attendeeImages, picked],
    ));
  }

  Future<void> _removeMember(String member) async {
    final shouldRemove = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _RemoveMemberSheet(member: member),
    );
    if (shouldRemove != true) return;
    _update(_event.value.copyWith(
      attendeeImages: [
        for (final image in _event.value.attendeeImages)
          if (image != member) image,
      ],
    ));
  }

  Future<void> _editDescription() async {
    final l = AppLocalizations.of(context);
    final next = await _promptText(
      context,
      title: l.taskDetailEditDescription,
      hint: l.taskDetailDescriptionHint,
      initialValue: _event.value.description ?? '',
      multiline: true,
    );
    if (next == null) return;
    _update(_event.value.copyWith(description: next));
  }

  Future<void> _editTitle() async {
    final l = AppLocalizations.of(context);
    final next = await _promptText(
      context,
      title: l.taskDetailEditTitle,
      hint: l.taskDetailEventNameHint,
      initialValue: _event.value.title,
    );
    if (next == null || next.isEmpty) return;
    _update(_event.value.copyWith(title: next));
  }

  Future<void> _editLocation() async {
    final l = AppLocalizations.of(context);
    final next = await _promptText(
      context,
      title: l.taskDetailEditLocation,
      hint: l.taskDetailLocationHint,
      initialValue: _event.value.location,
    );
    if (next == null) return;
    _update(_event.value.copyWith(location: next));
  }

  Future<void> _pickStartDate() async {
    final e = _event.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: e.startDate ?? e.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;
    final normalized = DateUtils.dateOnly(picked);
    _update(e.copyWith(date: normalized, startDate: normalized));
  }

  Future<void> _pickDueDate() async {
    final e = _event.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: e.dueDate ?? e.startDate ?? e.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;
    _update(e.copyWith(dueDate: DateUtils.dateOnly(picked)));
  }

  Future<void> _pickStartTime() async {
    final e = _event.value;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: e.startMinutes ~/ 60,
        minute: e.startMinutes % 60,
      ),
    );
    if (picked == null) return;
    _update(e.copyWith(startMinutes: picked.hour * 60 + picked.minute));
  }

  Future<void> _pickDuration() async {
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _ChoiceSheet<int>(
        title: l.calendarFieldDuration,
        values: const [30, 45, 60, 90, 120],
        selected: _event.value.durationMinutes,
        labelFor: (v) => l.taskDetailDurationMinutesLabel(v),
      ),
    );
    if (picked == null) return;
    _update(_event.value.copyWith(durationMinutes: picked));
  }

  Future<void> _pickPriority() async {
    final picked = await showModalBottomSheet<TaskPriority>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _PriorityPickerSheet(current: _event.value.priority),
    );
    if (picked == null) return;
    _update(_event.value.copyWith(priority: picked));
  }

  Future<void> _pickColor() async {
    final current = EventColorPreset(
        _event.value.backgroundColor, _event.value.accentColor);
    final picked = await showModalBottomSheet<EventColorPreset>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _ColorPickerSheet(current: current),
    );
    if (picked == null) return;
    _update(_event.value.copyWith(
      backgroundColor: picked.background,
      accentColor: picked.accent,
    ));
  }

  Future<void> _pickIcon() async {
    final picked = await showModalBottomSheet<TaskIcon>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _IconPickerSheet(current: _event.value.icon),
    );
    if (picked == null) return;
    _update(_event.value.copyWith(icon: picked));
  }

  Future<void> _addAttachment() async {
    final source = await showModalBottomSheet<_AttachmentSource>(
      context: context,
      backgroundColor: _DetailColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _AttachmentSourceSheet(),
    );
    if (source == null) return;

    Attachment? result;
    try {
      result = source == _AttachmentSource.camera
          ? await AttachmentStore.instance.pickImageFromCamera()
          : await AttachmentStore.instance.pickImageFromGallery();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).taskDetailAttachImageError)),
        );
      }
    }
    if (result == null) return;
    _update(_event.value.copyWith(
      attachments: [..._event.value.attachments, result],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = _DetailColors.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: c.gradientBottom,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: c.accent,
              surface: c.surface,
            ),
        splashColor: c.accent.withValues(alpha: 0.08),
        highlightColor: c.accent.withValues(alpha: 0.06),
      ),
      child: Scaffold(
        backgroundColor: c.gradientBottom,
        body: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [c.gradientTop, c.gradientBottom],
                stops: [0.0, 0.42],
              ),
            ),
            child: SafeArea(
              child: ValueListenableBuilder<CalendarEventData>(
                valueListenable: _event,
                builder: (context, event, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(
                          onBack: () => Navigator.of(context).maybePop(),
                          icon: event.icon,
                          onIconTap: _pickIcon,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _pickPriority,
                                borderRadius: BorderRadius.circular(20),
                                child: _PriorityPill(priority: event.priority),
                              ),
                              const SizedBox(height: 14),
                              InkWell(
                                onTap: _editTitle,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Text(
                                    event.title,
                                    style: GoogleFonts.lato(
                                      color:
                                          _DetailColors.of(context).textPrimary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _EventMetaGrid(
                                event: event,
                                onLocationTap: _editLocation,
                                onTimeTap: _pickStartTime,
                                onDurationTap: _pickDuration,
                                onColorTap: _pickColor,
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: _DateTile(
                                      label: l.taskDetailStartDate,
                                      date: event.startDate,
                                      onTap: _pickStartDate,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: _DateTile(
                                      label: l.taskDetailDueDate,
                                      date: event.dueDate,
                                      onTap: _pickDueDate,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  _SectionLabel(l.taskDetailDescription),
                                  const Spacer(),
                                  _IconActionButton(
                                    icon: Icons.edit_outlined,
                                    onTap: _editDescription,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: _editDescription,
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    (event.description ?? '').isEmpty
                                        ? l.taskDetailDescriptionHint
                                        : event.description!,
                                    style: GoogleFonts.lato(
                                      color: (event.description ?? '').isEmpty
                                          ? _DetailColors.of(context)
                                              .textSecondary
                                              .withValues(alpha: 0.7)
                                          : _DetailColors.of(context)
                                              .textSecondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      fontStyle:
                                          (event.description ?? '').isEmpty
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _SectionLabel(l.taskDetailTeamMember),
                              const SizedBox(height: 10),
                              _TeamRow(
                                members: event.attendeeImages,
                                progress: _computeProgress(event),
                                onAdd: _addMember,
                                onRemove: _removeMember,
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  _SectionLabel(l.taskDetailAttachments),
                                  const Spacer(),
                                  _IconActionButton(
                                    icon: Icons.add,
                                    onTap: _addAttachment,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (event.attachments.isEmpty)
                                InkWell(
                                  onTap: _addAttachment,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: _DetailColors.of(context).surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _DetailColors.of(context).border,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.attach_file,
                                            color: _DetailColors.of(context)
                                                .accent,
                                            size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          l.taskDetailAddAttachment,
                                          style: GoogleFonts.lato(
                                            color: _DetailColors.of(context)
                                                .accent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 70,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: event.attachments.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (_, i) => _AttachmentCard(
                                      attachment: event.attachments[i],
                                      previewLabel: l.taskDetailPreview,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  _SectionLabel(l.taskDetailTaskDetail),
                                  const Spacer(),
                                  _AddTaskButton(
                                    label: l.taskDetailAddTask,
                                    onTap: _addGroup,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ReorderableListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                buildDefaultDragHandles: false,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: event.subtaskGroups.length,
                                onReorder: _reorderGroups,
                                itemBuilder: (context, index) {
                                  final g = event.subtaskGroups[index];
                                  return Padding(
                                    key: ValueKey(g.id),
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _SubtaskGroupCard(
                                      index: index,
                                      group: g,
                                      onToggleSubtask: (id) =>
                                          _toggleSubtask(g.id, id),
                                      onToggleExpanded: () =>
                                          _toggleGroupExpanded(g.id),
                                      onAddSubtask: () => _addSubtask(g.id),
                                      onReorderSubtask: (oldIndex, newIndex) =>
                                          _reorderSubtasks(
                                        g.id,
                                        oldIndex,
                                        newIndex,
                                      ),
                                      onOpenComments: () => _openComments(g),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final TaskIcon icon;
  final VoidCallback onIconTap;
  const _TopBar({
    required this.onBack,
    required this.icon,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 14),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_ios_new,
                color: _DetailColors.of(context).textPrimary, size: 20),
          ),
          const Spacer(),
          Material(
            color: _DetailColors.of(context).accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: onIconTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8A77F5),
                      _DetailColors.of(context).accent
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _DetailColors.of(context)
                          .accent
                          .withValues(alpha: 0.32),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(taskIconData(icon), color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityPill({required this.priority});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (bg, fg, label) = switch (priority) {
      TaskPriority.high => (
          _kHighPillBg,
          _kHighPillFg,
          l.taskDetailPriorityHigh
        ),
      TaskPriority.medium => (
          const Color(0xFFFFF1D6),
          const Color(0xFFB37A1A),
          l.taskDetailPriorityMedium
        ),
      TaskPriority.low => (
          const Color(0xFFDDEFE2),
          const Color(0xFF2F8F5C),
          l.taskDetailPriorityLow
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          color: fg,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _DetailColors.of(context).accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.calendar_month_rounded,
                color: _DetailColors.of(context).accent, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(
                    color: _DetailColors.of(context).textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date == null ? '—' : _formatDate(date!, context),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: _DetailColors.of(context).textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetaGrid extends StatelessWidget {
  final CalendarEventData event;
  final VoidCallback onLocationTap;
  final VoidCallback onTimeTap;
  final VoidCallback onDurationTap;
  final VoidCallback onColorTap;

  const _EventMetaGrid({
    required this.event,
    required this.onLocationTap,
    required this.onTimeTap,
    required this.onDurationTap,
    required this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _MetaChip(
          icon: Icons.place_outlined,
          label: event.location.isEmpty
              ? AppLocalizations.of(context).taskDetailAddLocation
              : event.location,
          onTap: onLocationTap,
        ),
        _MetaChip(
          icon: Icons.schedule_rounded,
          label: _startLabel(event.startMinutes, context),
          onTap: onTimeTap,
        ),
        _MetaChip(
          icon: Icons.timer_outlined,
          label: AppLocalizations.of(context)
              .taskDetailDurationMinutesLabel(event.durationMinutes),
          onTap: onDurationTap,
        ),
        _MetaChip(
          icon: Icons.palette_outlined,
          label: AppLocalizations.of(context).taskDetailColorLabel,
          color: event.accentColor,
          onTap: onColorTap,
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _DetailColors.of(context).surface.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 220),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _DetailColors.of(context).border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 16, color: color ?? _DetailColors.of(context).accent),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: _DetailColors.of(context).textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: _DetailColors.of(context).textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _DetailColors.of(context).accentSoft,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, color: _DetailColors.of(context).accent, size: 18),
        ),
      ),
    );
  }
}

class _TeamRow extends StatefulWidget {
  final List<String> members;
  final double progress;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const _TeamRow({
    required this.members,
    required this.progress,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_TeamRow> createState() => _TeamRowState();
}

class _TeamRowState extends State<_TeamRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressAnim = Tween<double>(
      begin: widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_TeamRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.progress - widget.progress).abs() > 0.0001) {
      final from = _progressAnim.value;
      _progressAnim = Tween<double>(
        begin: from,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const avatarSize = 36.0;
    const overlap = 24.0;
    final visible = widget.members.take(4).toList();
    final stackWidth =
        visible.isEmpty ? 0.0 : avatarSize + (visible.length - 1) * overlap;

    return Row(
      children: [
        if (visible.isNotEmpty)
          SizedBox(
            width: stackWidth,
            height: avatarSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (var i = 0; i < visible.length; i++)
                  Positioned(
                    left: i * overlap,
                    child: _RemovableAvatar(
                      image: visible[i],
                      size: avatarSize,
                      onRemove: () => widget.onRemove(visible[i]),
                    ),
                  ),
              ],
            ),
          ),
        if (widget.members.length > visible.length) ...[
          const SizedBox(width: 8),
          Container(
            width: avatarSize,
            height: avatarSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _DetailColors.of(context).accentSoft,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '+${widget.members.length - visible.length}',
              style: GoogleFonts.lato(
                color: _DetailColors.of(context).accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
        const SizedBox(width: 10),
        Material(
          color: _DetailColors.of(context).accent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: widget.onAdd,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: _progressAnim,
          builder: (context, _) {
            final value = _progressAnim.value.clamp(0.0, 1.0);
            return SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: _DetailColors.of(context).accentSoft,
                      valueColor: AlwaysStoppedAnimation(
                          _DetailColors.of(context).accent),
                    ),
                  ),
                  Text(
                    "${(value * 100).round()}%",
                    style: GoogleFonts.lato(
                      color: _DetailColors.of(context).accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RemovableAvatar extends StatelessWidget {
  final String image;
  final double size;
  final VoidCallback onRemove;

  const _RemovableAvatar({
    required this.image,
    required this.size,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      onLongPress: onRemove,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _DetailColors.of(context).textPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final Attachment attachment;
  final String previewLabel;
  const _AttachmentCard({required this.attachment, required this.previewLabel});

  @override
  Widget build(BuildContext context) {
    final isImage = attachment.kind == AttachmentKind.image;
    final tileColor =
        isImage ? const Color(0xFF6FCCB7) : _DetailColors.of(context).accent;
    final icon = isImage ? Icons.image_outlined : Icons.description_outlined;

    return Container(
      width: 220,
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
      decoration: BoxDecoration(
        color: _DetailColors.of(context).surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _DetailColors.of(context).border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: AttachmentPreview(
              attachment: attachment,
              fallbackColor: tileColor,
              fallbackIcon: icon,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: _DetailColors.of(context).textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      attachment.sizeLabel,
                      style: GoogleFonts.lato(
                        color: _DetailColors.of(context).textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "  •  ",
                      style: GoogleFonts.lato(
                        color: _DetailColors.of(context).textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      previewLabel,
                      style: GoogleFonts.lato(
                        color: _DetailColors.of(context).accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddTaskButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _DetailColors.of(context).accentSoft,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add,
                  color: _DetailColors.of(context).accent, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.lato(
                  color: _DetailColors.of(context).accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubtaskGroupCard extends StatelessWidget {
  final int index;
  final SubtaskGroup group;
  final ValueChanged<String> onToggleSubtask;
  final VoidCallback onToggleExpanded;
  final VoidCallback onAddSubtask;
  final ReorderCallback onReorderSubtask;
  final VoidCallback onOpenComments;

  const _SubtaskGroupCard({
    required this.index,
    required this.group,
    required this.onToggleSubtask,
    required this.onToggleExpanded,
    required this.onAddSubtask,
    required this.onReorderSubtask,
    required this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _DetailColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _DetailColors.of(context).border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpanded,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_indicator,
                      color: _DetailColors.of(context).textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      group.title,
                      style: GoogleFonts.lato(
                        color: _DetailColors.of(context).textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    group.expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _DetailColors.of(context).textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (group.expanded) ...[
            ReorderableListView.builder(
              shrinkWrap: true,
              primary: false,
              buildDefaultDragHandles: false,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: group.subtasks.length,
              onReorder: onReorderSubtask,
              itemBuilder: (context, index) {
                final s = group.subtasks[index];
                return Padding(
                  key: ValueKey(s.id),
                  padding: const EdgeInsets.fromLTRB(34, 0, 14, 10),
                  child: _SubtaskRow(
                    index: index,
                    subtask: s,
                    onTap: () => onToggleSubtask(s.id),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 0, 14, 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: onAddSubtask,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add,
                              size: 16,
                              color: _DetailColors.of(context).accent),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context).taskDetailAddSubtask,
                            style: GoogleFonts.lato(
                              color: _DetailColors.of(context).accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onOpenComments,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            size: 16,
                            color: _DetailColors.of(context).textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${group.effectiveCommentsCount}",
                            style: GoogleFonts.lato(
                              color: _DetailColors.of(context).textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubtaskRow extends StatelessWidget {
  final int index;
  final Subtask subtask;
  final VoidCallback onTap;
  const _SubtaskRow({
    required this.index,
    required this.subtask,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(top: 1, right: 6),
                child: Icon(
                  Icons.drag_indicator,
                  color: _DetailColors.of(context)
                      .textSecondary
                      .withValues(alpha: 0.65),
                  size: 16,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: subtask.done
                    ? _DetailColors.of(context).accent
                    : Colors.transparent,
                border: Border.all(
                  color: subtask.done
                      ? _DetailColors.of(context).accent
                      : _DetailColors.of(context).border,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: subtask.done
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                subtask.title,
                style: GoogleFonts.lato(
                  color: subtask.done
                      ? _DetailColors.of(context).textSecondary
                      : _DetailColors.of(context).textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final SubtaskGroup group;

  const _CommentsSheet({required this.group});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    Navigator.of(context).pop(message);
  }

  @override
  Widget build(BuildContext context) {
    final c = _DetailColors.of(context);
    final comments = widget.group.comments;
    final hiddenCount = widget.group.commentsCount > comments.length
        ? widget.group.commentsCount - comments.length
        : 0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.78,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetGrabber(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).taskDetailComments,
                      style: GoogleFonts.lato(
                        color: c.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.group.effectiveCommentsCount}',
                    style: GoogleFonts.lato(
                      color: c.accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.group.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: c.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: comments.isEmpty && hiddenCount == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          child: Text(
                            AppLocalizations.of(context).taskDetailNoComments,
                            style: GoogleFonts.lato(
                              color: c.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          if (hiddenCount > 0)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.accentSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context).taskDetailOldCommentsHidden(hiddenCount),
                                style: GoogleFonts.lato(
                                  color: c.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          for (final comment in comments)
                            _CommentTile(comment: comment),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      style: GoogleFonts.lato(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).taskDetailCommentHint,
                        hintStyle: GoogleFonts.lato(
                          color: c.textSecondary,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: c.gradientBottom,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: c.accent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _submit,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final TaskComment comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final c = _DetailColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.gradientBottom,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  comment.author,
                  style: GoogleFonts.lato(
                    color: c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _formatCommentTime(comment.createdAt, AppLocalizations.of(context)),
                style: GoogleFonts.lato(
                  color: c.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment.message,
            style: GoogleFonts.lato(
              color: c.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberPickerSheet extends StatelessWidget {
  final List<String> available;
  const _MemberPickerSheet({required this.available});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            l.taskDetailAddMember,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final p in available)
                InkWell(
                  onTap: () => Navigator.of(context).pop(p),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _DetailColors.of(context).border, width: 2),
                      image: DecorationImage(
                        image: AssetImage(p),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RemoveMemberSheet extends StatelessWidget {
  final String member;

  const _RemoveMemberSheet({required this.member});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _DetailColors.of(context).border, width: 2),
                  image: DecorationImage(
                    image: AssetImage(member),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.taskDetailRemoveMemberTitle,
                  style: GoogleFonts.lato(
                    color: _DetailColors.of(context).textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: _DetailColors.of(context).border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l.commonCancel,
                    style: GoogleFonts.lato(
                      color: _DetailColors.of(context).textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC0392B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l.commonRemove,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconPickerSheet extends StatelessWidget {
  final TaskIcon current;
  const _IconPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            l.taskDetailChooseIcon,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final i in TaskIcon.values)
                InkWell(
                  onTap: () => Navigator.of(context).pop(i),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8A77F5),
                          _DetailColors.of(context).accent
                        ],
                      ),
                      border: Border.all(
                        color: i == current
                            ? _DetailColors.of(context).textPrimary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(taskIconData(i), color: Colors.white, size: 26),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachmentSourceSheet extends StatelessWidget {
  const _AttachmentSourceSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            AppLocalizations.of(context).taskDetailAddImage,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _SourceTile(
            icon: Icons.photo_library_outlined,
            title: AppLocalizations.of(context).taskDetailChooseFromGallery,
            subtitle: AppLocalizations.of(context).taskDetailGallerySubtitle,
            onTap: () => Navigator.of(context).pop(_AttachmentSource.gallery),
          ),
          const SizedBox(height: 10),
          _SourceTile(
            icon: Icons.photo_camera_outlined,
            title: AppLocalizations.of(context).taskDetailOpenCamera,
            subtitle: AppLocalizations.of(context).taskDetailCameraSubtitle,
            onTap: () => Navigator.of(context).pop(_AttachmentSource.camera),
          ),
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _DetailColors.of(context).gradientBottom,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _DetailColors.of(context).border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _DetailColors.of(context).accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Icon(icon, color: _DetailColors.of(context).accent, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      color: _DetailColors.of(context).textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      color: _DetailColors.of(context).textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityPickerSheet extends StatelessWidget {
  final TaskPriority current;
  const _PriorityPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            l.taskDetailPriorityLabel,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PriorityOption(
                selected: current == TaskPriority.high,
                label: l.taskDetailPriorityHigh,
                priority: TaskPriority.high,
              ),
              _PriorityOption(
                selected: current == TaskPriority.medium,
                label: l.taskDetailPriorityMedium,
                priority: TaskPriority.medium,
              ),
              _PriorityOption(
                selected: current == TaskPriority.low,
                label: l.taskDetailPriorityLow,
                priority: TaskPriority.low,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final bool selected;
  final String label;
  final TaskPriority priority;

  const _PriorityOption({
    required this.selected,
    required this.label,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(priority),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? _DetailColors.of(context).accentSoft
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _DetailColors.of(context).accent
                : _DetailColors.of(context).border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.lato(
            color: selected
                ? _DetailColors.of(context).accent
                : _DetailColors.of(context).textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  final EventColorPreset current;
  const _ColorPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            AppLocalizations.of(context).taskDetailEventColorLabel,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final p in EventColorPreset.all)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(p),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: p.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _samePreset(p, current)
                              ? _DetailColors.of(context).textPrimary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: p.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _samePreset(EventColorPreset a, EventColorPreset b) =>
      a.background.toARGB32() == b.background.toARGB32() &&
      a.accent.toARGB32() == b.accent.toARGB32();
}

class _ChoiceSheet<T> extends StatelessWidget {
  final String title;
  final List<T> values;
  final T selected;
  final String Function(T value) labelFor;

  const _ChoiceSheet({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelFor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetGrabber(),
          Text(
            title,
            style: GoogleFonts.lato(
              color: _DetailColors.of(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final value in values)
                InkWell(
                  onTap: () => Navigator.of(context).pop(value),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: value == selected
                          ? _DetailColors.of(context).accentSoft
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: value == selected
                            ? _DetailColors.of(context).accent
                            : _DetailColors.of(context).border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      labelFor(value),
                      style: GoogleFonts.lato(
                        color: value == selected
                            ? _DetailColors.of(context).accent
                            : _DetailColors.of(context).textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetGrabber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _DetailColors.of(context).border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

Future<String?> _promptText(
  BuildContext context, {
  required String title,
  required String hint,
  String initialValue = '',
  bool multiline = false,
}) {
  final controller = TextEditingController(text: initialValue);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: _DetailColors.of(context).surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      final l = AppLocalizations.of(ctx);
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          20 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetGrabber(),
            Text(
              title,
              style: GoogleFonts.lato(
                color: _DetailColors.of(context).textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              minLines: multiline ? 3 : 1,
              maxLines: multiline ? 6 : 1,
              style: GoogleFonts.lato(
                color: _DetailColors.of(context).textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.lato(
                  color: _DetailColors.of(context).textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: _DetailColors.of(context).gradientBottom,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted:
                  multiline ? null : (v) => Navigator.of(ctx).pop(v.trim()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _DetailColors.of(context).accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: Text(
                  l.commonSave,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String _formatDate(DateTime d, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(d);
}

String _startLabel(int minutes, BuildContext context) {
  final h = (minutes ~/ 60) % 24;
  final m = minutes % 60;
  return TimeOfDay(hour: h, minute: m).format(context);
}

String _formatCommentTime(DateTime value, AppLocalizations l) {
  final now = DateTime.now();
  final diff = now.difference(value);
  if (diff.inMinutes < 1) return l.taskDetailCommentNow;
  if (diff.inMinutes < 60) return l.taskDetailCommentMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l.taskDetailCommentHoursAgo(diff.inHours);
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}';
}

String _newId() => CalendarStore.newId();
