import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import 'history_card.dart';

class HistorySection extends StatelessWidget {
  final String title;
  final List<HistoryEntry> entries;

  const HistorySection({super.key, required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...entries.map((entry) => HistoryCard(entry: entry)),
        const SizedBox(height: 16),
      ],
    );
  }
}
