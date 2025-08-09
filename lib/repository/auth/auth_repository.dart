import 'dart:async';

import 'package:reach_out_rural/constants/auth_exceptions.dart';
import 'package:reach_out_rural/services/api/api_service.dart';
import 'package:reach_out_rural/services/db/shared_pref_helper.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  final ApiService _apiService;
  final SharedPreferencesHelper _prefsHelper;

  AuthenticationRepository(this._apiService, this._prefsHelper) {
    _init();
  }

  Stream<AuthenticationStatus> get status => _controller.stream;

  Future<void> _init() async {
    final token = await _prefsHelper.getString('token');
    if (token != null && token.isNotEmpty) {
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> logIn({required String phone}) async {
    try {
      final response = await _apiService.patientLogin({'phonenumber': phone});
      if (response.statusCode == 200) {
        await _prefsHelper.setString('token', response.data['token']);
        await _prefsHelper.setString('phone', phone);
        _controller.add(AuthenticationStatus.authenticated);
        return;
      } else if (response.statusCode == 400) {
        final errorMessage = response.data['error'] ?? 'Invalid phone number';
        throw LogInException(errorMessage);
      } else {
        throw LogInException(
            'Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is LogInException) {
        rethrow;
      }
      throw LogInException('Unexpected error occurred: $e');
    }
  }

  Future<void> register({required String phone}) async {
    try {
      final response =
          await _apiService.patientRegister({'phonenumber': phone});
      if (response.statusCode == 201) {
        await _prefsHelper.setString('token', response.data['token']);
        await _prefsHelper.setString('phone', phone);
        _controller.add(AuthenticationStatus.authenticated);
        return;
      } else if (response.statusCode == 400) {
        final errorMessage = response.data['error'] ?? 'Invalid phone number';
        throw SignUpException(errorMessage);
      } else {
        throw SignUpException(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SignUpException) {
        rethrow;
      }
      throw SignUpException('Unexpected error occurred: $e');
    }
  }

  void logOut() async {
    await _prefsHelper.clear();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
