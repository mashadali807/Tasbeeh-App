import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/custom_dhikr_model.dart';
import '../controllers/custom_dhikr_controller.dart';

class CustomDhikrFormScreen extends StatefulWidget {
  const CustomDhikrFormScreen({super.key});

  @override
  State<CustomDhikrFormScreen> createState() => _CustomDhikrFormScreenState();
}

class _CustomDhikrFormScreenState extends State<CustomDhikrFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _arabicController;
  late TextEditingController _translationController;
  late TextEditingController _notesController;
  late TextEditingController _targetController;

  CustomDhikr? _editingDhikr;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is CustomDhikr) {
      _editingDhikr = args;
    }
    _nameController = TextEditingController(text: _editingDhikr?.name ?? '');
    _arabicController = TextEditingController(
      text: _editingDhikr?.arabic ?? '',
    );
    _translationController = TextEditingController(
      text: _editingDhikr?.translation ?? '',
    );
    _notesController = TextEditingController(text: _editingDhikr?.notes ?? '');
    _targetController = TextEditingController(
      text: (_editingDhikr?.targetCount ?? 33).toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arabicController.dispose();
    _translationController.dispose();
    _notesController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final controller = Get.find<CustomDhikrController>();
    final dhikr = CustomDhikr(
      id: _editingDhikr?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      arabic: _arabicController.text.trim().isEmpty
          ? null
          : _arabicController.text.trim(),
      translation: _translationController.text.trim().isEmpty
          ? null
          : _translationController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      targetCount: int.tryParse(_targetController.text.trim()) ?? 33,
      createdAt: _editingDhikr?.createdAt ?? DateTime.now(),
      updatedAt: _editingDhikr != null ? DateTime.now() : null,
    );
    controller.saveDhikr(dhikr);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2A1F) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : const Color(0xFF0B8A5E).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                      ),
                      onPressed: Get.back,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _editingDhikr == null
                            ? 'Create Custom Dhikr'
                            : 'Edit Custom Dhikr',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B8A5E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Card(
                        elevation: 6,
                        shadowColor: isDark
                            ? Colors.black54
                            : const Color(0xFF0B8A5E).withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      const Color(0xFF1E2A1E),
                                      const Color(0xFF2A3A2A),
                                    ]
                                  : [Colors.white, const Color(0xFFF8FAF9)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name field
                                _buildFormField(
                                  controller: _nameController,
                                  label: 'Dhikr Name *',
                                  icon: Icons.text_fields_rounded,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                // Arabic field
                                _buildFormField(
                                  controller: _arabicController,
                                  label: 'Arabic Text (optional)',
                                  icon: Icons.translate_rounded,
                                  isArabic: true,
                                ),
                                const SizedBox(height: 16),
                                // Translation field
                                _buildFormField(
                                  controller: _translationController,
                                  label: 'Translation (optional)',
                                  icon: Icons.language_rounded,
                                ),
                                const SizedBox(height: 16),
                                // Notes field (multiline)
                                _buildFormField(
                                  controller: _notesController,
                                  label: 'Notes (optional)',
                                  icon: Icons.note_alt_rounded,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                // Target count field
                                _buildFormField(
                                  controller: _targetController,
                                  label: 'Target Count',
                                  icon: Icons.numbers_rounded,
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Required';
                                    if (int.tryParse(v) == null)
                                      return 'Must be a number';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                // Submit button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0B8A5E),
                                        Color(0xFFD4AF37),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF0B8A5E,
                                        ).withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      _editingDhikr == null
                                          ? 'Create Dhikr'
                                          : 'Update Dhikr',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isArabic = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey[700],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0B8A5E)),
            filled: true,
            fillColor: isDark ? const Color(0xFF2A3A2A) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0B8A5E), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey[300]!,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
