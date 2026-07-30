import 'package:flutter/material.dart';
import '../models/history_entry.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEntry entry;

  const HistoryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: entry.isCompleted ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.dhikrName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (entry.arabicText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.arabicText!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${entry.count} / ${entry.targetCount}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.durationString,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.formattedTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: entry.isCompleted
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.isCompleted ? '✅ Done' : '⏳ Partial',
                style: TextStyle(
                  fontSize: 12,
                  color: entry.isCompleted ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
