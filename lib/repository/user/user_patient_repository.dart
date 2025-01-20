import 'dart:async';
import 'dart:convert';

import 'package:reach_out_rural/models/patient.dart';
import 'package:reach_out_rural/services/db/shared_pref_helper.dart';

class UserPatientRepository {
  Patient? _userPatient;
  final SharedPreferencesHelper _prefs;
  static const String _userPatientKey = 'user_patient';

  UserPatientRepository(this._prefs);

  Future<Patient?> getUserPatient() async {
    if (_userPatient != null) return _userPatient;

    final String? userPatient = await _prefs.getString(_userPatientKey);
    if (userPatient != null) {
      _userPatient = Patient.fromJson(jsonDecode(userPatient));
    }

    return _userPatient;
  }

  Future<void> saveUserPatient(Patient patient) async {
    _userPatient = patient;
    final String userPatientJson = jsonEncode(patient.toJson());
    await _prefs.setString(_userPatientKey, userPatientJson);
  }

  Future<void> clearUserPatient() async {
    _userPatient = null;
    await _prefs.remove(_userPatientKey);
  }
}
