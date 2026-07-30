import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tasbeeh/features/dhikr_library/widgets/favourite_button.dart';
import '../models/dhikr_model.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          dhikr.arabic,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dhikr.transliteration,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              dhikr.translationEn,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: FavoriteButton(
          isFavorite: isFavorite,
          onPressed: onFavoriteToggle,
        ),
        onTap: () {
          Get.toNamed('/dhikr-detail', arguments: dhikr);
        },
      ),
    );
  }
}
