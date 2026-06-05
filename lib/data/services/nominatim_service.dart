import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for geocoding using OpenStreetMap Nominatim API.
/// Free, no API key required. Rate limit: 1 request/second.
class NominatimService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  /// Search for addresses matching the query.
  /// Returns a list of [NominatimResult] objects.
  Future<List<NominatimResult>> searchAddress(String query) async {
    if (query.trim().length < 3) {
      return [];
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '5',
        'countrycodes': 'ua', // Focus on Ukraine
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'PopytkaUA/1.0 (ridesharing app)'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => NominatimResult.fromJson(item)).toList();
      }
    } catch (e) {
      // Silently fail, return empty list
    }

    return [];
  }
}

/// Represents a single address result from Nominatim.
class NominatimResult {
  final String displayName;
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;

  NominatimResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
  });

  factory NominatimResult.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    return NominatimResult(
      displayName: json['display_name'] as String? ?? '',
      latitude: double.tryParse(json['lat'].toString()) ?? 0.0,
      longitude: double.tryParse(json['lon'].toString()) ?? 0.0,
      city:
          address['city'] as String? ??
          address['town'] as String? ??
          address['village'] as String?,
      state: address['state'] as String?,
    );
  }

  /// Short name for display in the text field after selection.
  String get shortName {
    if (city != null && state != null) {
      return '$city, $state';
    }
    if (city != null) {
      return city!;
    }
    // Fallback: first part of display name
    final parts = displayName.split(',');
    return parts.take(2).join(',').trim();
  }
}
