import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  final String name;
  final String speciality;
  final String latitude;
  final String longitude;
  final double distance;

  const Hospital(
      this.name, this.speciality, this.latitude, this.longitude, this.distance);

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      json['name'] as String,
      json['speciality'] as String,
      json['lat'].toString(),
      json['lon'].toString(),
      json['distance'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'speciality': speciality,
      'lat': latitude,
      'lon': longitude,
      'distance': distance,
    };
  }

  Hospital copyWith({
    String? name,
    String? speciality,
    String? latitude,
    String? longitude,
    double? distance,
  }) {
    return Hospital(
      name ?? this.name,
      speciality ?? this.speciality,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      distance ?? this.distance,
    );
  }

  static const empty = Hospital('-', '-', '-', '-', 0.0);

  @override
  String toString() {
    return 'Hospital{name: $name, speciality: $speciality, lat: $latitude, lon: $longitude, distance: $distance}';
  }

  @override
  List<Object> get props => [name, speciality, latitude, longitude, distance];
}
