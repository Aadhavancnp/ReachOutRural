import 'dart:convert';

import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:reach_out_rural/services/db/shared_pref_helper.dart';

class StorageRepository {
  static const String _doctorsKey = 'doctors';
  static const String _hospitalsKey = 'hospitals';
  static const String _localeKey = 'locale';
  static const String _userOnboardingKey = 'user_onboarding';
  static const String _splashScreenKey = 'user_splash';
  final SharedPreferencesHelper _sharedPrefHelper;
  StorageRepository(this._sharedPrefHelper);

  Future<void> setUserOnboarding(bool isOnboardedCompleted) async {
    await _sharedPrefHelper.setBool(_userOnboardingKey, isOnboardedCompleted);
  }

  Future<bool?> getUserOnboarding() async {
    return await _sharedPrefHelper.getBool(_userOnboardingKey) ?? false;
  }

  Future<void> saveLocale(String locale) async {
    await _sharedPrefHelper.setString(_localeKey, locale);
  }

  Future<String?> getLocale() async {
    return await _sharedPrefHelper.getString(_localeKey) ?? 'en';
  }

  Future<void> saveDoctors(List<Doctor> doctors) async {
    final doctorsDataJson = jsonEncode(doctors);
    await _sharedPrefHelper.setString(_doctorsKey, doctorsDataJson);
  }

  Future<List<Doctor>> getDoctors() async {
    final doctorsDataJson = await _sharedPrefHelper.getString(_doctorsKey);
    if (doctorsDataJson != null) {
      final List<dynamic> doctorsData = jsonDecode(doctorsDataJson);
      final List<Doctor> doctors = [];
      for (final doctor in doctorsData) {
        doctors.add(Doctor.fromJson(doctor));
      }
      return doctors;
    }
    return [];
  }

  Future<void> saveHospitals(List<Hospital> hospitals) async {
    final hospitalsDataJson = jsonEncode(hospitals);
    await _sharedPrefHelper.setString(_hospitalsKey, hospitalsDataJson);
  }

  Future<List<Hospital>> getHospitals() async {
    final hospitalsDataJson = await _sharedPrefHelper.getString(_hospitalsKey);
    if (hospitalsDataJson != null) {
      final List<dynamic> hospitalsData = jsonDecode(hospitalsDataJson);
      final List<Hospital> hospitals = [];
      for (final hospital in hospitalsData) {
        hospitals.add(Hospital.fromJson(hospital));
      }
      return hospitals;
    }
    return [];
  }

  Future<void> removeDoctors() async {
    await _sharedPrefHelper.remove(_doctorsKey);
  }

  Future<void> removeHospitals() async {
    await _sharedPrefHelper.remove(_hospitalsKey);
  }

  Future<void> setSplashScreenShown() async {
    await _sharedPrefHelper.setBool(_splashScreenKey, true);
  }

  Future<bool?> isSplashScreenShown() async {
    return await _sharedPrefHelper.getBool(_splashScreenKey) ?? false;
  }

  Future<void> clear() async {
    await _sharedPrefHelper.clear();
  }
}
