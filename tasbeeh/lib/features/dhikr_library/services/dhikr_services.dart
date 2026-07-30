import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dhikr_model.dart';

class DhikrService {
  static const String _dhikrJsonPath = 'assets/dhikr_list.json';

  Future<List<Dhikr>> loadDhikrList() async {
    try {
      final String jsonString = await rootBundle.loadString(_dhikrJsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => Dhikr.fromJson(e)).toList();
    } catch (e) {
      print('Error loading dhikr list: $e');
      return [];
    }
  }
}
