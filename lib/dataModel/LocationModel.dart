class LocationModel {
  final String placeId;
  final String locationName;
  final String pincode;
  final String fullAddress;
  final double? latitude;
  final double? longitude;

  LocationModel({
    required this.placeId,
    required this.locationName,
    required this.pincode,
    required this.fullAddress,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'placeId': placeId,
    'locationName': locationName,
    'pincode': pincode,
    'fullAddress': fullAddress,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    placeId: json['placeId'] ?? '',
    locationName: json['locationName'] ?? '',
    pincode: json['pincode'] ?? '',
    fullAddress: json['fullAddress'] ?? '',
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
  );
}
