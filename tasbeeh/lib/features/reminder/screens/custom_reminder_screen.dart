import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/reminder/controllers/reminder_controller.dart';
import '../models/reminder_model.dart';

class CustomReminderScreen extends StatefulWidget {
  const CustomReminderScreen({super.key});

  @override
  State<CustomReminderScreen> createState() => _CustomReminderScreenState();
}

class _CustomReminderScreenState extends State<CustomReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TimeOfDay _selectedTime;
  late List<int> _selectedDays;
  Reminder? _editingReminder;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Reminder) {
      _editingReminder = args;
    }
    _titleController = TextEditingController(
      text: _editingReminder?.title ?? '',
    );
    _bodyController = TextEditingController(text: _editingReminder?.body ?? '');
    final time = _editingReminder?.time ?? DateTime.now();
    _selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
    _selectedDays = _editingReminder?.daysOfWeek ?? [1, 2, 3, 4, 5, 6, 7];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
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
                        _editingReminder == null
                            ? 'Add Custom Reminder'
                            : 'Edit Reminder',
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
                                // Title field
                                _buildFormField(
                                  controller: _titleController,
                                  label: 'Title *',
                                  icon: Icons.title_rounded,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Body/Message field
                                _buildFormField(
                                  controller: _bodyController,
                                  label: 'Message *',
                                  icon: Icons.message_rounded,
                                  maxLines: 3,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Time picker
                                _buildTimePicker(context),
                                const SizedBox(height: 16),

                                // Days of week
                                _buildDaysSelector(),
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
                                    onPressed: _saveReminder,
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
                                      _editingReminder == null
                                          ? 'Create Reminder'
                                          : 'Update Reminder',
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
    int maxLines = 1,
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

  Widget _buildTimePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color(0xFF0B8A5E),
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (newTime != null) {
          setState(() {
            _selectedTime = newTime;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A3A2A) : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: const Color(0xFF0B8A5E)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    _selectedTime.format(context),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = [
      {'label': 'Mon', 'value': 1},
      {'label': 'Tue', 'value': 2},
      {'label': 'Wed', 'value': 3},
      {'label': 'Thu', 'value': 4},
      {'label': 'Fri', 'value': 5},
      {'label': 'Sat', 'value': 6},
      {'label': 'Sun', 'value': 7},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat on:',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey[700],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            final isSelected = _selectedDays.contains(day['value']);
            return FilterChip(
              label: Text(
                day['label'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day['value']);
                  } else {
                    _selectedDays.add(day['value'] as int);
                  }
                });
              },
              selectedColor: const Color(0xFF0B8A5E),
              backgroundColor: isDark
                  ? const Color(0xFF2A3A2A)
                  : Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey[700]),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : (isDark ? Colors.white24 : Colors.grey[300]!),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one day.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<RemindersController>();
    final now = DateTime.now();
    final time = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = Reminder(
      id:
          _editingReminder?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      type: ReminderType.custom,
      time: time,
      daysOfWeek: _selectedDays,
      isEnabled: true,
    );

    if (_editingReminder != null) {
      controller.editReminder(reminder);
    } else {
      controller.addCustomReminder(reminder);
    }

    Get.back();
  }
}
