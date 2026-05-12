import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Services/calendar_store.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';

/// Bottom-sheet form for creating or editing a [CalendarEventData].
///
/// Returns `true` if the store was mutated (caller can show a snackbar).
class CalendarEventFormSheet extends StatefulWidget {
  final DateTime initialDate;
  final int? initialStartMinutes;
  final CalendarEventData? existing;

  const CalendarEventFormSheet({
    Key? key,
    required this.initialDate,
    this.initialStartMinutes,
    this.existing,
  }) : super(key: key);

  @override
  State<CalendarEventFormSheet> createState() => _CalendarEventFormSheetState();
}

class _CalendarEventFormSheetState extends State<CalendarEventFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;

  late DateTime _date;
  late TimeOfDay _start;
  late int _durationMinutes;
  late EventColorPreset _color;
  late TaskIcon _icon;

  static const _durations = [30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _locationCtrl = TextEditingController(text: e?.location ?? '');
    _date = DateUtils.dateOnly(e?.date ?? widget.initialDate);
    if (e != null) {
      _start = TimeOfDay(
        hour: e.startMinutes ~/ 60,
        minute: e.startMinutes % 60,
      );
    } else if (widget.initialStartMinutes != null) {
      final m = widget.initialStartMinutes!.clamp(0, 24 * 60 - 1);
      _start = TimeOfDay(hour: m ~/ 60, minute: m % 60);
    } else {
      _start = const TimeOfDay(hour: 9, minute: 0);
    }
    _durationMinutes = e?.durationMinutes ?? 60;
    _color = e != null
        ? _matchPreset(e.backgroundColor, e.accentColor)
        : EventColorPreset.lilac;
    _icon = e?.icon ?? TaskIcon.briefcase;
  }

  static EventColorPreset _matchPreset(Color bg, Color accent) {
    for (final p in EventColorPreset.all) {
      if (p.background.toARGB32() == bg.toARGB32() &&
          p.accent.toARGB32() == accent.toARGB32()) {
        return p;
      }
    }
    return EventColorPreset.lilac;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = DateUtils.dateOnly(picked));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _start);
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final isEditing = widget.existing != null;
    final startMinutes = _start.hour * 60 + _start.minute;
    final event = (widget.existing ??
            CalendarEventData(
              id: CalendarStore.newId(),
              date: _date,
              startMinutes: startMinutes,
              durationMinutes: _durationMinutes,
              title: _titleCtrl.text.trim(),
              location: _locationCtrl.text.trim(),
              backgroundColor: _color.background,
              accentColor: _color.accent,
              attendeeImages: const [],
            ))
        .copyWith(
      date: _date,
      startMinutes: startMinutes,
      durationMinutes: _durationMinutes,
      title: _titleCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      backgroundColor: _color.background,
      accentColor: _color.accent,
      icon: _icon,
    );

    if (isEditing) {
      await CalendarStore.instance.update(event);
    } else {
      await CalendarStore.instance.add(event);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isEditing = widget.existing != null;
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.92,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: palette.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isEditing ? l.calendarEditEvent : l.calendarNewEvent,
                      style: GoogleFonts.lato(
                        color: palette.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleCtrl,
                      style: GoogleFonts.lato(
                          color: palette.textPrimary, fontSize: 16),
                      decoration:
                          _inputDecoration(palette, l.calendarFieldTitle),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.calendarTitleRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _locationCtrl,
                      style: GoogleFonts.lato(
                          color: palette.textPrimary, fontSize: 16),
                      decoration:
                          _inputDecoration(palette, l.calendarFieldLocation),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FieldTile(
                            label: l.calendarFieldDate,
                            value: _formatDate(_date),
                            onTap: _pickDate,
                            palette: palette,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _FieldTile(
                            label: l.calendarFieldStart,
                            value: _start.format(context),
                            onTap: _pickTime,
                            palette: palette,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l.calendarFieldDuration,
                      style: GoogleFonts.lato(
                        color: palette.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _durations.map((d) {
                        final selected = d == _durationMinutes;
                        return ChoiceChip(
                          label: Text(l.calendarDurationMinutes(d)),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _durationMinutes = d),
                          selectedColor: palette.accent.withValues(alpha: 0.18),
                          backgroundColor: palette.surfaceElevated,
                          labelStyle: GoogleFonts.lato(
                            color:
                                selected ? palette.accent : palette.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  selected ? palette.accent : palette.divider,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l.calendarFieldColor,
                      style: GoogleFonts.lato(
                        color: palette.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: EventColorPreset.all.map((p) {
                        final selected = p == _color;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _color = p),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: p.background,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      selected ? p.accent : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: p.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l.taskDetailChooseIcon,
                      style: GoogleFonts.lato(
                        color: palette.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final icon in TaskIcon.values)
                          InkWell(
                            onTap: () => setState(() => _icon = icon),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_color.background, _color.accent],
                                ),
                                border: Border.all(
                                  color: icon == _icon
                                      ? palette.textPrimary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                taskIconData(icon),
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        if (isEditing)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await CalendarStore.instance
                                    .remove(widget.existing!.id);
                                if (mounted) Navigator.of(context).pop(true);
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: palette.divider),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                l.commonDelete,
                                style: GoogleFonts.lato(
                                  color: const Color(0xFFC0392B),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        if (isEditing) const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.accent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              isEditing ? l.commonSave : l.commonCreate,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppPalette palette, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.lato(color: palette.textMuted),
      filled: true,
      fillColor: palette.surfaceElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

class _FieldTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final AppPalette palette;

  const _FieldTile({
    required this.label,
    required this.value,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.lato(
                color: palette.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.lato(
                color: palette.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
