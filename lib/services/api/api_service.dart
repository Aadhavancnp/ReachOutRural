import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:reach_out_rural/constants/auth_exceptions.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:reach_out_rural/services/api/dio_client.dart';

class ApiService {
  static const String _patientLogin = 'users/patient/login';
  static const String _doctorLogin = 'doctor/login';
  static const String _patientRegister = 'users/patient/register';
  static const String _doctorRegister = 'doctor/register';
  static const String _checkNavigation = 'classify/v1/check-navigation/';
  static const String _getDoctors = 'users/get-doctors';
  static const String _updateProfile = 'users/update-profile/?id=';
  static const String _chatBot = 'classify/v1/medical-chatbot/?id=';
  static const String _textToVoice = 'classify/v1/text-voice-generator/';
  static const String _predict =
      'https://invisible-fredrika-koyeb-cibiyanna-organization-af4ed798.koyeb.app/predict';
  static const String _getNearbyHospitals = 'users/nearby-hospital/?id=';

  final DioClient _dioClient;

  ApiService(this._dioClient);

  Future<Response> patientLogin(Map<String, dynamic> patientData) async {
    try {
      final response = await _dioClient.post(_patientLogin, data: patientData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> doctorLogin(Map<String, dynamic> doctorData) async {
    try {
      final response = await _dioClient.post(_doctorLogin, data: doctorData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> patientRegister(Map<String, dynamic> patientData) async {
    try {
      final response =
          await _dioClient.post(_patientRegister, data: patientData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> doctorRegister(Map<String, dynamic> doctorData) async {
    try {
      final response = await _dioClient.post(_doctorRegister, data: doctorData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<List<Doctor>> getDoctors() async {
    try {
      final response = await _dioClient.get(_getDoctors);
      final List<Doctor> doctors = [];
      for (final doctor in response.data) {
        doctors.add(Doctor.fromJson(doctor));
      }
      log('Doctors: $doctors');
      return doctors;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<List<Hospital>> getNearbyHospitals(String phone) async {
    try {
      final response =
          await _dioClient.get('$_getNearbyHospitals$phone&user_role=patient');
      final List<Hospital> hospitals = [];
      for (final hospital in response.data["hospitals"]) {
        hospitals.add(Hospital.fromJson(hospital));
      }
      log('Hospitals: $hospitals');
      return hospitals;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> getDoctorBasedOnSpecialization(String specialization) async {
    try {
      final response =
          await _dioClient.post('$_getDoctors?specialization=$specialization');
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final phoneNumber = profileData['phonenumber'];
      final response = await _dioClient.patch(
          "$_updateProfile$phoneNumber&user_role=patient",
          data: profileData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> checkNavigation(Map<String, dynamic> navigationData) async {
    try {
      final response =
          await _dioClient.post(_checkNavigation, data: navigationData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> chatbot(Map<String, dynamic> chatBotData) async {
    try {
      final phoneNumber = chatBotData['phone_number'];
      chatBotData.remove('phone_number');
      final response =
          await _dioClient.post(_chatBot + phoneNumber!, data: chatBotData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> textToVoice(Map<String, dynamic> textToVoiceData) async {
    try {
      final response =
          await _dioClient.post(_textToVoice, data: textToVoiceData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Response> predict(FormData predictData) async {
    try {
      final response = await _dioClient.post(_predict, data: predictData);
      return response;
    } on DioException catch (e) {
      throw _handleApiError(e);
    }
  }

  Exception _handleApiError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final errorMessage =
            error.response?.data['error'] ?? 'Unknown error occurred';
        switch (error.response?.statusCode) {
          case 400:
            return BadRequestException(errorMessage);
          case 401:
            return UnauthorizedException(errorMessage);
          case 404:
            return NotFoundException(errorMessage);
          case 500:
          default:
            return ServerException(errorMessage);
        }
      } else {
        return NetworkException(error.message ?? 'Unknown network error');
      }
    } else {
      return Exception('Unexpected error: $error');
    }
  }
}
