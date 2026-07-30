import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quote_model.dart';

class QuoteService {
  static const String _quoteJsonPath =
      'assets/quotes.json'; // we'll need to create this file

  Future<List<Quote>> loadQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString(_quoteJsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => Quote.fromJson(e)).toList();
    } catch (e) {
      // Fallback to some default quotes
      return [
        Quote(
          text: 'The best of you are those who are best to their families.',
          author: 'Prophet Muhammad ﷺ',
        ),
        Quote(
          text: 'Remembrance of Allah brings peace to the heart.',
          author: 'Quran 13:28',
        ),
      ];
    }
  }

  Future<Quote> getRandomQuote() async {
    final quotes = await loadQuotes();
    if (quotes.isEmpty) return Quote(text: 'SubhanAllah', author: null);
    final randomIndex = DateTime.now().millisecondsSinceEpoch % quotes.length;
    return quotes[randomIndex];
  }

  // Store a local JSON asset (we'll provide a sample file)
}
