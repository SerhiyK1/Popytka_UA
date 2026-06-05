import 'package:flutter_test/flutter_test.dart';
import 'package:popytka_ua/domain/models/location_model.dart';

void main() {
  group('LocationModel', () {
    const double latitude = 49.8397;
    const double longitude = 24.0297;
    const String city = 'Lviv';
    const String address = 'Rynok Square';

    const locationModel = LocationModel(
      latitude: latitude,
      longitude: longitude,
      city: city,
      address: address,
    );

    test('should be created with correct values', () {
      // Assert
      expect(locationModel.latitude, latitude);
      expect(locationModel.longitude, longitude);
      expect(locationModel.city, city);
      expect(locationModel.address, address);
    });

    test('should correctly serialize to and from JSON', () {
      // Act
      final json = locationModel.toJson();
      final fromJson = LocationModel.fromJson(json);

      // Assert
      expect(fromJson, locationModel);
    });

    test('instances with the same values should be equal', () {
      // Arrange
      const locationModel1 = LocationModel(
        latitude: latitude,
        longitude: longitude,
        city: city,
        address: address,
      );
      const locationModel2 = LocationModel(
        latitude: latitude,
        longitude: longitude,
        city: city,
        address: address,
      );

      // Assert
      expect(locationModel1, locationModel2);
    });
  });
}
