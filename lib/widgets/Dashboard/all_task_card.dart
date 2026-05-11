import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/_dashboard_card_palette.dart';

class AllTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final int tasksDone;
  final int tasksTotal;
  final List<String> avatarAssets;
  final int extraAvatars;
  final int commentsCount;

  const AllTaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.tasksDone,
    required this.tasksTotal,
    required this.avatarAssets,
    this.extraAvatars = 0,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = DashboardCardPalette.of(context);
    final progress = tasksTotal == 0 ? 0.0 : tasksDone / tasksTotal;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: p.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                label: l.priorityMedium,
                background: p.amberSoft,
                foreground: p.amber,
              ),
              const SizedBox(width: 8),
              _Pill(
                label: date,
                background: p.accentSoft,
                foreground: p.accent,
                leading:
                    Icon(FeatherIcons.calendar, size: 14, color: p.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FeatherIcons.briefcase, color: p.accent, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: p.titleText,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: p.bodyText,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.progressLabel,
                style: GoogleFonts.lato(
                  fontSize: 13,
                  color: p.titleText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                l.projectTasksProgress(tasksDone, tasksTotal),
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: p.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: p.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(p.accent),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AvatarStackWithOverflow(
                assets: avatarAssets,
                extra: extraAvatars,
                accent: p.accent,
                ringColor: p.cardBackground,
                overflowText: p.cardBackground,
              ),
              Row(
                children: [
                  Icon(FeatherIcons.messageCircle,
                      size: 20, color: p.primaryIcon),
                  const SizedBox(width: 4),
                  Text(
                    '$commentsCount',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: p.primaryIcon,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(FeatherIcons.share2, size: 20, color: p.primaryIcon),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final Widget? leading;

  const _Pill({
    Key? key,
    required this.label,
    required this.background,
    required this.foreground,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStackWithOverflow extends StatelessWidget {
  final List<String> assets;
  final int extra;
  final Color accent;
  final Color ringColor;
  final Color overflowText;
  static const double _size = 32;
  static const double _overlap = 12;

  const _AvatarStackWithOverflow({
    Key? key,
    required this.assets,
    required this.extra,
    required this.accent,
    required this.ringColor,
    required this.overflowText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalSlots = assets.length + (extra > 0 ? 1 : 0);
    return SizedBox(
      height: _size,
      width: _size + (_size - _overlap) * (totalSlots - 1),
      child: Stack(
        children: [
          for (int i = 0; i < assets.length; i++)
            Positioned(
              left: i * (_size - _overlap),
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: 2),
                  image: DecorationImage(
                    image: AssetImage(assets[i]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: assets.length * (_size - _overlap),
              child: Container(
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                  border: Border.all(color: ringColor, width: 2),
                ),
                child: Text(
                  '+$extra',
                  style: GoogleFonts.lato(
                    color: overflowText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
