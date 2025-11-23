import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'notification_service.dart';

class LocationService {
  static const double _notificationRadius = 100.0; // 100 meters

  static Future<bool> requestPermissions() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> checkPermissions() async {
    return await Permission.location.isGranted;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        final granted = await requestPermissions();
        if (!granted) return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<double> calculateDistance(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) async {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }

  // Check if user is near a specific location
  static Future<bool> isNearLocation(double lat, double lon) async {
    final currentPosition = await getCurrentLocation();
    if (currentPosition == null) return false;

    final distance = await calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      lat,
      lon,
    );

    return distance <= _notificationRadius;
  }

  // Start monitoring location for specific stores/locations
  static void startLocationMonitoring(List<StoreLocation> stores) async {
    if (!await checkPermissions()) return;

    // This is a simplified version. In production, you'd use background geofencing
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50, // Update every 50 meters
      ),
    ).listen((Position position) {
      _checkNearbyStores(position, stores);
    });
  }

  static void _checkNearbyStores(Position position, List<StoreLocation> stores) async {
    for (var store in stores) {
      final distance = await calculateDistance(
        position.latitude,
        position.longitude,
        store.latitude,
        store.longitude,
      );

      if (distance <= _notificationRadius && !store.hasNotified) {
        // Send notification
        NotificationService.showLocationBasedReminder(
          'Near ${store.name}',
          'You have items on your shopping list!',
        );
        store.hasNotified = true;
      } else if (distance > _notificationRadius * 2) {
        // Reset notification flag when far away
        store.hasNotified = false;
      }
    }
  }
}

class StoreLocation {
  final String name;
  final double latitude;
  final double longitude;
  bool hasNotified;

  StoreLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.hasNotified = false,
  });
}
