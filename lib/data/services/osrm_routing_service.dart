import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'osrm_routing_service.g.dart';

@riverpod
OsrmRoutingService osrmRoutingService(Ref ref) {
  return OsrmRoutingService();
}

/// Service to fetch real road routes using OSRM (Open Source Routing Machine).
class OsrmRoutingService {
  static const String _baseUrl = 'http://router.project-osrm.org/route/v1/driving';

  /// Fetches a list of LatLng points representing the road route between locations, including optional intermediate waypoints.
  Future<List<LatLng>> getRoute(LatLng start, LatLng end, {List<LatLng> waypoints = const []}) async {
    final List<LatLng> allPoints = [start, ...waypoints, end];
    final String coordinates = allPoints.map((p) => '${p.longitude},${p.latitude}').join(';');
    final Uri uri = Uri.parse('$_baseUrl/$coordinates?overview=full&geometries=geojson');

    try {
      debugPrint('OSRM Request: $uri');
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'PopytkaUA/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final geometry = data['routes'][0]['geometry'];
          final List<dynamic> coords = geometry['coordinates'];
          
          debugPrint('OSRM Success: found ${coords.length} points');
          return coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();
        } else {
          debugPrint('OSRM Error: No routes found in response');
        }
      } else {
        debugPrint('OSRM Error: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching OSRM route: $e');
    }

    // Fallback to a straight line if service fails
    return [start, end];
  }
}
