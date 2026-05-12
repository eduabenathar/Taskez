import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEventData event;
  final VoidCallback? onTap;

  const CalendarEventCard({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: event.backgroundColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: context.palette.shadow,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: event.accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      taskIconData(event.icon),
                      size: 15,
                      color: event.accentColor,
                    ),
                  ),
                  Icon(Icons.access_time, size: 16, color: event.accentColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      event.timeLabel,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: event.accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: const Color(0xFF202124),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.location,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: const Color(0xB3202124),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _AttendeeStack(images: event.attendeeImages),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendeeStack extends StatelessWidget {
  final List<String> images;

  const _AttendeeStack({required this.images});

  @override
  Widget build(BuildContext context) {
    const avatarSize = 26.0;
    const overlap = 15.0;
    final visibleImages = images.take(4).toList();
    if (visibleImages.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: avatarSize + (visibleImages.length - 1) * overlap,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var index = 0; index < visibleImages.length; index++)
            Positioned(
              left: index * overlap,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: eventCardBorderColor, width: 2),
                  image: DecorationImage(
                    image: AssetImage(visibleImages[index]),
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

const eventCardBorderColor = Color(0xFFFFFFFF);
