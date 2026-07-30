import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingDhikr == null ? 'Create Dhikr' : 'Edit Dhikr'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arabicController,
                decoration: const InputDecoration(
                  labelText: 'Arabic Text (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _translationController,
                decoration: const InputDecoration(
                  labelText: 'Translation (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(labelText: 'Target Count'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_editingDhikr == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
