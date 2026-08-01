import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/daily_adhkar_model.dart';

class DailyAdhkarService {
  static const String _jsonPath = 'assets/daily_adhkar.json';

  Future<List<DailyAdhkar>> loadAdhkar() async {
    try {
      final jsonString = await rootBundle.loadString(_jsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => DailyAdhkar.fromJson(e)).toList();
    } catch (e) {
      print('⚠️ Failed to load daily adhkar: $e');
      return []; // return empty list
    }
  }
}
