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
        _controller.add(AuthenticationStatus.authenticated);
        return;
      } else {
        throw LogInException(response.data['error']);
      }
    } on AuthException catch (e) {
      throw LogInException(e.message);
    }
  }

  Future<void> register({required String phone}) async {
    try {
      final response =
          await _apiService.patientRegister({'phonenumber': phone});
      if (response.statusCode == 201) {
        await _prefsHelper.setString('token', response.data['token']);
        _controller.add(AuthenticationStatus.authenticated);
        return;
      } else {
        throw SignUpException(response.data['error']);
      }
    } on AuthException catch (e) {
      throw SignUpException(e.message);
    }
  }

  void logOut() async {
    await _prefsHelper.clear();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
