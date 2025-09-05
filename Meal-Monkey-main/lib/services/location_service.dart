import 'dart:math';

class LocationService {
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Calculate dynamic delivery charge based on distance
  static double calculateDeliveryCharge(double distanceInKm) {
    // Base delivery charge
    double baseCharge = 20.0;

    if (distanceInKm <= 2.0) {
      // Within 2km - base charge
      return baseCharge;
    } else if (distanceInKm <= 5.0) {
      // 2-5km - base + ₹5 per km
      return baseCharge + ((distanceInKm - 2.0) * 5.0);
    } else if (distanceInKm <= 10.0) {
      // 5-10km - base + ₹15 for first 3km + ₹8 per km after 5km
      return baseCharge + 15.0 + ((distanceInKm - 5.0) * 8.0);
    } else {
      // Above 10km - base + ₹15 + ₹40 + ₹12 per km after 10km
      return baseCharge + 15.0 + 40.0 + ((distanceInKm - 10.0) * 12.0);
    }
  }

  /// Calculate estimated delivery time based on distance
  static int calculateDeliveryTime(double distanceInKm) {
    // Base preparation time
    int basePreparationTime = 15; // 15 minutes for food preparation

    // Delivery time calculation (assuming average speed of 25 km/h)
    double deliveryTimeInHours = distanceInKm / 25.0;
    int deliveryTimeInMinutes = (deliveryTimeInHours * 60).round();

    // Add some buffer time for traffic and other delays
    int bufferTime = (distanceInKm * 2).round(); // 2 minutes per km as buffer

    int totalTime = basePreparationTime + deliveryTimeInMinutes + bufferTime;

    // Minimum delivery time is 20 minutes, maximum is 90 minutes
    return totalTime.clamp(20, 90);
  }

  /// Get delivery charge breakdown for display
  static Map<String, dynamic> getDeliveryBreakdown(double distanceInKm) {
    double baseCharge = 20.0;
    double extraCharge = 0.0;
    String description = '';

    if (distanceInKm <= 2.0) {
      description = 'Within 2km radius';
    } else if (distanceInKm <= 5.0) {
      extraCharge = (distanceInKm - 2.0) * 5.0;
      description = 'Base ₹20 + ₹5/km for distance > 2km';
    } else if (distanceInKm <= 10.0) {
      extraCharge = 15.0 + ((distanceInKm - 5.0) * 8.0);
      description = 'Base ₹20 + ₹15 (2-5km) + ₹8/km for distance > 5km';
    } else {
      extraCharge = 15.0 + 40.0 + ((distanceInKm - 10.0) * 12.0);
      description =
          'Base ₹20 + ₹15 (2-5km) + ₹40 (5-10km) + ₹12/km for distance > 10km';
    }

    return {
      'baseCharge': baseCharge,
      'extraCharge': extraCharge,
      'totalCharge': baseCharge + extraCharge,
      'distance': distanceInKm,
      'description': description,
    };
  }
}

/// Model for delivery information
class DeliveryInfo {
  final double distance;
  final double charge;
  final int estimatedTime;
  final Map<String, dynamic> breakdown;

  DeliveryInfo({
    required this.distance,
    required this.charge,
    required this.estimatedTime,
    required this.breakdown,
  });

  factory DeliveryInfo.calculate({
    required double userLat,
    required double userLon,
    required double restaurantLat,
    required double restaurantLon,
  }) {
    double distance = LocationService.calculateDistance(
        userLat, userLon, restaurantLat, restaurantLon);

    double charge = LocationService.calculateDeliveryCharge(distance);
    int estimatedTime = LocationService.calculateDeliveryTime(distance);
    Map<String, dynamic> breakdown =
        LocationService.getDeliveryBreakdown(distance);

    return DeliveryInfo(
      distance: distance,
      charge: charge,
      estimatedTime: estimatedTime,
      breakdown: breakdown,
    );
  }
}
