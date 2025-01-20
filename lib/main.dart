import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reach_out_rural/app/app.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/services/api/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesAsync();
  final dio = DioClient(Dio());
  final locale = getLocaleFromCode(await prefs.getString('locale') ?? 'en');
  runApp(App(prefs: prefs, dio: dio, locale: locale));
}
