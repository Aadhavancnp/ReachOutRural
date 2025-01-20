import 'package:equatable/equatable.dart';

enum Gender { male, female, other }

// ignore: constant_identifier_names
enum BloodGroup { A, B, AB, O }

enum BloodGroupType { positive, negative }

class Patient extends Equatable {
  const Patient(
      this.id,
      this.name,
      this.age,
      this.phone,
      this.email,
      this.gender,
      this.height,
      this.weight,
      this.bloodGroup,
      this.bloodGroupType,
      this.latitude,
      this.longitude,
      this.location,
      this.bio);

  final int id;
  final String name;
  final int age;
  final String phone;
  final String email;
  final Gender gender;
  final String height;
  final String weight;
  final BloodGroup bloodGroup;
  final BloodGroupType bloodGroupType;
  final String latitude;
  final String longitude;
  final String location;
  final String bio;

  @override
  List<Object> get props => [
        id,
        name,
        age,
        phone,
        email,
        gender,
        height,
        weight,
        bloodGroup,
        bloodGroupType,
        latitude,
        longitude,
        location,
        bio
      ];

  static const empty = Patient(0, '-', 0, '-', '-', Gender.male, '-', '-',
      BloodGroup.A, BloodGroupType.positive, '-', '-', '-', '-');

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      json['id'],
      json['name'],
      json['age'],
      json['phone'],
      json['email'],
      _getGender(json['gender']),
      json['height'],
      json['weight'],
      _getBloodGroup(json['bloodGroup']),
      _getBloodGroupType(json['bloodGroupType']),
      json['latitude'],
      json['longitude'],
      json['location'],
      json['bio'],
    );
  }

  static Gender _getGender(String genderStr) {
    switch (genderStr) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        return Gender.male; // Default to male if parsing fails
    }
  }

  static BloodGroup _getBloodGroup(String bloodGroupStr) {
    switch (bloodGroupStr) {
      case 'A':
        return BloodGroup.A;
      case 'B':
        return BloodGroup.B;
      case 'AB':
        return BloodGroup.AB;
      case 'O':
        return BloodGroup.O;
      default:
        return BloodGroup.A; // Default to A if parsing fails
    }
  }

  static BloodGroupType _getBloodGroupType(String bloodGroupTypeStr) {
    switch (bloodGroupTypeStr) {
      case 'positive':
        return BloodGroupType.positive;
      case 'negative':
        return BloodGroupType.negative;
      default:
        return BloodGroupType.positive; // Default to positive if parsing fails
    }
  }

  Patient copyWith({
    int? id,
    String? name,
    int? age,
    String? phone,
    String? email,
    Gender gender = Gender.male,
    String? height,
    String? weight,
    BloodGroup? bloodGroup,
    BloodGroupType? bloodGroupType,
    String? latitude,
    String? longitude,
    String? location,
    String? bio,
  }) {
    return Patient(
      id ?? this.id,
      name ?? this.name,
      age ?? this.age,
      phone ?? this.phone,
      email ?? this.email,
      gender,
      height ?? this.height,
      weight ?? this.weight,
      bloodGroup ?? this.bloodGroup,
      bloodGroupType ?? this.bloodGroupType,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      location ?? this.location,
      bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'phonenumber': phone,
      'email': email,
      'gender': gender.toString().split('.').last,
      'height': height,
      'weight': weight,
      'bloodgroup': bloodGroup.toString().split('.').last,
      'bloodgroupType': bloodGroupType.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': location,
      'bio': bio,
    };
  }

  @override
  String toString() {
    return 'Patient{id: $id, name: $name, age: $age, phone: $phone, email: $email, gender: $gender, height: $height, weight: $weight, bloodGroup: $bloodGroup, bloodGroupType: $bloodGroupType, latitude: $latitude, longitude: $longitude, location: $location, bio: $bio}';
  }
}
