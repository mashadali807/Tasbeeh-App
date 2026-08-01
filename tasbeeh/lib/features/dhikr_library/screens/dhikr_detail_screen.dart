import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/dhikr_library/models/dhikr_model.dart';

class DhikrDetailScreen extends StatelessWidget {
  const DhikrDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Safely parse arguments
    final Dhikr dhikr = _parseArguments();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E0A),
                    Color(0xFF1A2A1F),
                    Color(0xFF0B8A5E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAF9),
                    Color(0xFFE8F5EE),
                    Color(0xFFD4EDDA),
                  ],
                ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF1A2A1F).withOpacity(0.9),
                                const Color(0xFF0B8A5E).withOpacity(0.6),
                              ]
                            : [
                                Colors.white.withOpacity(0.9),
                                const Color(0xFFE8F5EE).withOpacity(0.8),
                              ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0B8A5E),
                          ),
                          onPressed: Get.back,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            dhikr.transliteration,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0B8A5E),
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pinned: true,
              ),
              // Body
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Arabic Text
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black12 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF0B8A5E).withOpacity(0.3)
                                : const Color(0xFFD4AF37).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          dhikr.arabic,
                          style: GoogleFonts.amiri(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0B8A5E),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Transliteration
                    if (dhikr.transliteration.isNotEmpty)
                      Card(
                        elevation: 0,
                        color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isDark ? Colors.white10 : Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transliteration',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dhikr.transliteration,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Translation (English)
                    Card(
                      elevation: 0,
                      color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark ? Colors.white10 : Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Translation',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dhikr.translationEn,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (dhikr.translationUr != null) ...[
                      const SizedBox(height: 12),
                      Card(
                        elevation: 0,
                        color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isDark ? Colors.white10 : Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Urdu Translation',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dhikr.translationUr!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (dhikr.benefits != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isDark ? Colors.white10 : Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: const Color(0xFFD4AF37),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Benefits',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0B8A5E),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                dhikr.benefits!,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Recommended count + Start button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0B8A5E).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  '${dhikr.recommendedCount} times',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(
                                '/tasbeeh',
                                arguments: {
                                  'dhikrId': dhikr.id,
                                  'dhikrName': dhikr.transliteration,
                                  'recommendedCount': dhikr.recommendedCount,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0B8A5E),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow),
                            label: Text(
                              'Start',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper method to safely parse Get.arguments
  Dhikr _parseArguments() {
    final args = Get.arguments;
    if (args is Dhikr) {
      return args;
    } else if (args is Map<String, dynamic>) {
      return Dhikr.fromJson(args);
    } else {
      // Fallback – should never happen
      return Dhikr(
        id: 'unknown',
        arabic: 'Unknown',
        transliteration: 'Unknown',
        translationEn: 'Unknown',
      );
    }
  }
}
