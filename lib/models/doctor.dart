import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final int? id;
  final String name;
  final String? phone;
  final String? specialization;
  final int experienceYears;
  final String? location;
  final String? latitude;
  final String? longitude;
  final String? bio;

  const Doctor({
    this.id,
    required this.name,
    this.phone,
    this.specialization,
    required this.experienceYears,
    this.location,
    this.latitude,
    this.longitude,
    this.bio,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        specialization,
        experienceYears,
        location,
        latitude,
        longitude,
        bio,
      ];

  static const empty = Doctor(
    id: 0,
    name: '-',
    phone: '-',
    specialization: '-',
    experienceYears: 0,
    location: '-',
    latitude: '-',
    longitude: '-',
    bio: '-',
  );

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '-',
      phone: json['phonenumber'] as String?,
      specialization: json['specialization'] as String?,
      experienceYears: json['experience_years'] as int? ?? 0,
      location: json['location_name'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phonenumber': phone,
      'specialization': specialization,
      'experience_years': experienceYears,
      'location_name': location,
      'latitude': latitude != null ? double.tryParse(latitude!) : null,
      'longitude': longitude != null ? double.tryParse(longitude!) : null,
      'bio': bio,
    };
  }

  Doctor copyWith({
    int? id,
    String? name,
    String? phone,
    String? specialization,
    int? experienceYears,
    String? location,
    String? latitude,
    String? longitude,
    String? bio,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'Doctor { id: $id, name: $name, phone: $phone, specialization: $specialization, experienceYears: $experienceYears, location: $location, latitude: $latitude, longitude: $longitude, bio: $bio }';
  }
}
