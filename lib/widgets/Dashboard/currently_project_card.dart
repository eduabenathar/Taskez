import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Dashboard/_dashboard_card_palette.dart';

class CurrentlyProjectCard extends StatelessWidget {
  final String title;
  final String date;
  final int tasksDone;
  final int tasksTotal;
  final List<String> avatarAssets;
  final int commentsCount;

  const CurrentlyProjectCard({
    Key? key,
    required this.title,
    required this.date,
    required this.tasksDone,
    required this.tasksTotal,
    required this.avatarAssets,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = DashboardCardPalette.of(context);
    final progress = tasksTotal == 0 ? 0.0 : tasksDone / tasksTotal;

    return Container(
      width: 320,
      height: 220,
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Pill(
                    label: l.priorityHigh,
                    background: p.dangerSoft,
                    foreground: p.danger,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    label: date,
                    background: p.accentSoft,
                    foreground: p.accent,
                    leading: Icon(FeatherIcons.calendar,
                        size: 14, color: p.accent),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: p.accentSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(FeatherIcons.briefcase, color: p.accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: p.titleText,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.projectStatusInProgress,
                    style: GoogleFonts.lato(fontSize: 13, color: p.bodyText),
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
                  minHeight: 8,
                  backgroundColor: p.progressTrack,
                  valueColor: AlwaysStoppedAnimation<Color>(p.accent),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AvatarStack(
                      assets: avatarAssets, ringColor: p.cardBackground),
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
                      Icon(FeatherIcons.share2,
                          size: 20, color: p.primaryIcon),
                    ],
                  ),
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

class _AvatarStack extends StatelessWidget {
  final List<String> assets;
  final Color ringColor;
  static const double _size = 28;
  static const double _overlap = 10;

  const _AvatarStack({
    Key? key,
    required this.assets,
    required this.ringColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size,
      width: _size + (_size - _overlap) * (assets.length - 1),
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
        ],
      ),
    );
  }
}
