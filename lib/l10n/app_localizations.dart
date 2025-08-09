import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('es'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('si'),
    Locale('ta'),
    Locale('te'),
    Locale('ur')
  ];

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// Get Started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login description
  ///
  /// In en, this message translates to:
  /// **'Let\'\'s experience the joy of Reach Out Rural.'**
  String get login_desc;

  /// Phone Number
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Register description
  ///
  /// In en, this message translates to:
  /// **'Let\'\'s experience the joy of Reach Out Rural.'**
  String get register_desc;

  /// Don''t have an account?
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t have an account? '**
  String get dont_have_account;

  /// Already have an account?
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get have_account;

  /// Need help?
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get need_help;

  /// Invalid Mobile Number
  ///
  /// In en, this message translates to:
  /// **'Invalid Mobile Number'**
  String get invalid_phone_number;

  /// OTP Verification
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otp_verification;

  /// OTP Verification description
  ///
  /// In en, this message translates to:
  /// **'We sent your code to '**
  String get otp_verification_desc;

  /// OTP Expire
  ///
  /// In en, this message translates to:
  /// **'This code will expire in '**
  String get otp_expire;

  /// Resend OTP Code
  ///
  /// In en, this message translates to:
  /// **'Resend OTP Code'**
  String get resend_otp;

  /// Gender
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your Gender?'**
  String get what_is_gender;

  /// Age
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your Age?'**
  String get what_is_age;

  /// Male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Height
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your Height?'**
  String get what_is_height;

  /// Weight
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your Weight?'**
  String get what_is_weight;

  /// Blood Group
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your Blood Group?'**
  String get what_is_blood_group;

  /// Diagnosis
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// Diagnosis description
  ///
  /// In en, this message translates to:
  /// **'Press the button and start speaking...'**
  String get diagnosis_desc;

  /// Logged in successfully
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get login_success;

  /// Logged out successfully
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logged_out;

  /// Registered successfully
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get register_success;

  /// Profile updated successfully
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get proflie_update_success;

  /// Search for Doctors...
  ///
  /// In en, this message translates to:
  /// **'Search for Doctors...'**
  String get search_for_doctor;

  /// Book Appointments
  ///
  /// In en, this message translates to:
  /// **'Book Appointments'**
  String get book_appointment;

  /// Instant Video Consultation
  ///
  /// In en, this message translates to:
  /// **'Instant Video Consultation'**
  String get instant_vid_consultation;

  /// Nearby Doctors
  ///
  /// In en, this message translates to:
  /// **'Nearby Doctors'**
  String get nearby_doctors;

  /// View More Doctors
  ///
  /// In en, this message translates to:
  /// **'View More Doctors'**
  String get view_more_doctors;

  /// Learn More
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learn_more;

  /// Doctor Info
  ///
  /// In en, this message translates to:
  /// **'Doctor Info'**
  String get doctor_info;

  /// Nearby Hospitals
  ///
  /// In en, this message translates to:
  /// **'Nearby Hospitals'**
  String get nearby_hospitals;

  /// View More Hospitals
  ///
  /// In en, this message translates to:
  /// **'View More Hospitals'**
  String get view_more_hospitals;

  /// My Prescriptions
  ///
  /// In en, this message translates to:
  /// **'My Prescriptions'**
  String get my_prescriptions;

  /// My Appointments
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get my_appointments;

  /// Search Nearby Hospitals
  ///
  /// In en, this message translates to:
  /// **'Search Nearby Hospitals'**
  String get search_nearby_hospitals;

  /// Search for Nearby Hospitals...
  ///
  /// In en, this message translates to:
  /// **'Search for Nearby Hospitals...'**
  String get search_for_nearby_hospitals;

  /// Search Doctors
  ///
  /// In en, this message translates to:
  /// **'Search Doctors'**
  String get search_doctors;

  /// Search for Doctors...
  ///
  /// In en, this message translates to:
  /// **'Search for Doctors...'**
  String get search_for_doctors;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Prescriptions
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// Upload Prescription
  ///
  /// In en, this message translates to:
  /// **'Upload Prescription'**
  String get upload_prescription;

  /// Logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Edit Profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// Bio
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Age
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Gender
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Height
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Weight
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Blood Group
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get blood_group;

  /// Phone
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['as', 'bn', 'en', 'es', 'gu', 'hi', 'kn', 'ml', 'mr', 'ne', 'or', 'pa', 'si', 'ta', 'te', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as': return AppLocalizationsAs();
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
    case 'ml': return AppLocalizationsMl();
    case 'mr': return AppLocalizationsMr();
    case 'ne': return AppLocalizationsNe();
    case 'or': return AppLocalizationsOr();
    case 'pa': return AppLocalizationsPa();
    case 'si': return AppLocalizationsSi();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
    case 'ur': return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
