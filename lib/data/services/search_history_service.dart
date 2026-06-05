import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_history_service.g.dart';

/// A search entry containing from and to locations
class SearchEntry {
  final String from;
  final String to;

  SearchEntry({required this.from, required this.to});

  Map<String, dynamic> toJson() => {'from': from, 'to': to};

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    return SearchEntry(from: json['from'] as String, to: json['to'] as String);
  }

  String get displayText => '$from → $to';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchEntry &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;
}

@riverpod
SearchHistoryService searchHistoryService(Ref ref) {
  return SearchHistoryService();
}

/// Service for managing search history using SharedPreferences
class SearchHistoryService {
  static const String _storageKey = 'search_history';
  static const int _maxEntries = 5;

  /// Popular routes to show when history is empty
  static final List<SearchEntry> popularRoutes = [
    SearchEntry(from: 'Київ', to: 'Львів'),
    SearchEntry(from: 'Одеса', to: 'Київ'),
    SearchEntry(from: 'Харків', to: 'Дніпро'),
  ];

  /// Get search history from local storage
  Future<List<SearchEntry>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((item) => SearchEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new search entry to history
  /// Removes duplicates and keeps only the last [_maxEntries] entries
  Future<void> addSearchEntry(String from, String to) async {
    if (from.trim().isEmpty || to.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getSearchHistory();

      final newEntry = SearchEntry(from: from.trim(), to: to.trim());

      // Remove duplicate if exists
      history.removeWhere((entry) => entry == newEntry);

      // Add new entry at the beginning
      history.insert(0, newEntry);

      // Keep only last N entries
      final trimmedHistory = history.take(_maxEntries).toList();

      // Save to storage
      final jsonList = trimmedHistory.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      // Silently fail - not critical functionality
    }
  }

  /// Clear all search history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      // Silently fail
    }
  }

  /// Get entries to display - history if available, otherwise popular routes
  Future<List<SearchEntry>> getDisplayEntries() async {
    final history = await getSearchHistory();
    if (history.isEmpty) {
      return popularRoutes;
    }
    return history;
  }
}
