import 'package:flutter/material.dart';
import 'package:reach_out_rural/models/patient.dart';

const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF000000);
const kPrimaryColor = Color(0xFF027FFF);
const kGreyDotColor = Color(0xFFD8D8D8);
const kGreyColor = Color(0xFF9E9E9E);
const kErrorColor = Colors.redAccent;
const kSuccessColor = Colors.greenAccent;
const kWarningColor = Colors.amberAccent;
const kInfoColor = Colors.blueAccent;
const kAnimationDuration = Duration(milliseconds: 300);

const List<String> onBoardingScreens = [
  'assets/animations/onboarding1.json',
  'assets/animations/onboarding2.json',
  'assets/animations/onboarding3.json',
];

const List<String> bloodGroupAssets = [
  'assets/icons/A+.svg',
  'assets/icons/A-.svg',
  'assets/icons/B+.svg',
  'assets/icons/B-.svg',
  'assets/icons/AB+.svg',
  'assets/icons/AB-.svg',
  'assets/icons/O+.svg',
  'assets/icons/O-.svg',
];

const bloodGroupNames = {
  0: {BloodGroup.A, BloodGroupType.positive},
  1: {BloodGroup.A, BloodGroupType.negative},
  2: {BloodGroup.B, BloodGroupType.positive},
  3: {BloodGroup.B, BloodGroupType.negative},
  4: {BloodGroup.AB, BloodGroupType.positive},
  5: {BloodGroup.AB, BloodGroupType.negative},
  6: {BloodGroup.O, BloodGroupType.positive},
  7: {BloodGroup.O, BloodGroupType.negative},
};

const List<String> chatResponse = [
  "Based on the image, it appears you might have a wound. Here's what you can do to provide initial first aid:\n 1) Clean the wound: Gently wash the area with soap and cool running water to remove dirt and debris.\n"
      "\t2) Stop bleeding: Apply direct pressure with a clean cloth or bandage until the bleeding stops.\n"
      "\t3) Apply an antiseptic: Apply a thin layer of over-the-counter antiseptic ointment to help prevent infection.\n"
      "\t4) Cover the wound: Cover the area with a clean bandage to protect it from dirt and germs.\n"
      "\t5) Monitor for signs of infection: Watch for redness, swelling, warmth, pain, or drainage. If these symptoms worsen, seek medical attention.",
  "Based on the image you provided, it appears you may have a fungal skin infection called Ringworm.\n"
      "\tExplanation:\n"
      "\tRingworm is a common fungal infection of the skin. It is characterized by circular or oval patches of red, itchy skin that may be raised or flat. It is important to note that ringworm is not a worm, but rather a fungal infection.\n"
      "\n\tPrecaution:\n"
      "\t1) Avoid touching the affected area.\n"
      "\t2) Wash your hands frequently.\n"
      "\t3) Keep the affected area clean and dry.\n"
      "\t4) Avoid sharing personal items.\n"
      "\n\tTreatment:\n"
      "\tRingworm can be treated with over-the-counter antifungal creams, lotions, or sprays. However, if the infection is severe or does not respond to over-the-counter treatment, you may need to see a doctor for a prescription antifungal medication.\n"
];

const languageList = [
  "en",
  "es",
  "hi",
  "bn",
  "te",
  "ta",
  "ur",
  "gu",
  "kn",
  "or",
  "ml",
  "pa",
  "as",
  "mr",
  "ne",
  "si",
];

final Map<String, String> languageMap = {
  'Hindi': 'hi',
  'Bengali': 'bn',
  'Tamil': 'ta',
  'Telugu': 'te',
  'Kannada': 'kn',
  'Malayalam': 'ml',
  'Punjabi': 'pa',
  'Gujarati': 'gu',
  'Odia': 'or',
  'Urdu': 'ur',
  'English': 'en',
  'Spanish': 'es',
  'Assamese': 'as',
  'Marathi': 'mr',
  'Nepali': 'ne',
  'Sinhala': 'si',
};

const stateMap = {
  "Andhra Pradesh": "AP",
  "Arunachal Pradesh": "AR",
  "Assam": "AS",
  "Bihar": "BR",
  "Chhattisgarh": "CG",
  "Goa": "GA",
  "Gujarat": "GJ",
  "Haryana": "HR",
  "Himachal Pradesh": "HP",
  "Jharkhand": "JH",
  "Karnataka": "KA",
  "Kerala": "KL",
  "Madhya Pradesh": "MP",
  "Maharashtra": "MH",
  "Manipur": "MN",
  "Meghalaya": "ML",
  "Mizoram": "MZ",
  "Nagaland": "NL",
  "Odisha": "OD",
  "Punjab": "PB",
  "Rajasthan": "RJ",
  "Sikkim": "SK",
  "Tamil Nadu": "TN",
  "Telangana": "TG",
  "Tripura": "TR",
  "Uttarakhand": "UT",
  "Uttar Pradesh": "UP",
  "West Bengal": "WB",
  "Andaman and Nicobar Islands": "AN",
  "Chandigarh": "CH",
  "Dadra and Nagar Haveli and Daman and Diu": "DD",
  "Delhi": "DL",
  "Jammu and Kashmir": "JK",
  "Ladakh": "LA",
  "Lakshadweep": "LD",
  "Puducherry": "PY",
};

const countryMap = {
  "Afghanistan": "AF",
  "Albania": "AL",
  "Algeria": "DZ",
  "Andorra": "AD",
  "Angola": "AO",
  "Antigua and Barbuda": "AG",
  "Argentina": "AR",
  "Armenia": "AM",
  "Australia": "AU",
  "Austria": "AT",
  "Azerbaijan": "AZ",
  "Bahamas": "BS",
  "Bahrain": "BH",
  "Bangladesh": "BD",
  "Barbados": "BB",
  "Belarus": "BY",
  "Belgium": "BE",
  "Belize": "BZ",
  "Benin": "BJ",
  "Bhutan": "BT",
  "Bolivia": "BO",
  "Bosnia and Herzegovina": "BA",
  "Botswana": "BW",
  "Brazil": "BR",
  "Brunei": "BN",
  "Bulgaria": "BG",
  "Burkina Faso": "BF",
  "Burundi": "BI",
  "Cabo Verde": "CV",
  "Cambodia": "KH",
  "Cameroon": "CM",
  "Canada": "CA",
  "Central African Republic": "CF",
  "Chad": "TD",
  "Chile": "CL",
  "China": "CN",
  "Colombia": "CO",
  "Comoros": "KM",
  "Congo (Brazzaville)": "CG",
  "Congo (Kinshasa)": "CD",
  "Costa Rica": "CR",
  "Côte d'Ivoire": "CI",
  "Croatia": "HR",
  "Cuba": "CU",
  "Cyprus": "CY",
  "Czech Republic": "CZ",
  "Denmark": "DK",
  "Djibouti": "DJ",
  "Dominica": "DM",
  "Dominican Republic": "DO",
  "Ecuador": "EC",
  "Egypt": "EG",
  "El Salvador": "SV",
  "Equatorial Guinea": "GQ",
  "Eritrea": "ER",
  "Estonia": "EE",
  "Eswatini": "SZ",
  "Ethiopia": "ET",
  "Fiji": "FJ",
  "Finland": "FI",
  "France": "FR",
  "Gabon": "GA",
  "Gambia": "GM",
  "Georgia": "GE",
  "Germany": "DE",
  "Ghana": "GH",
  "Greece": "GR",
  "Grenada": "GD",
  "Guatemala": "GT",
  "Guinea": "GN",
  "Guinea-Bissau": "GW",
  "Guyana": "GY",
  "Haiti": "HT",
  "Honduras": "HN",
  "Hungary": "HU",
  "Iceland": "IS",
  "India": "IN",
  "Indonesia": "ID",
  "Iran": "IR",
  "Iraq": "IQ",
  "Ireland": "IE",
  "Israel": "IL",
  "Italy": "IT",
  "Jamaica": "JM",
  "Japan": "JP",
  "Jordan": "JO",
  "Kazakhstan": "KZ",
  "Kenya": "KE",
  "Kiribati": "KI",
  "Kuwait": "KW",
  "Kyrgyzstan": "KG",
  "Laos": "LA",
  "Latvia": "LV",
  "Lebanon": "LB",
  "Lesotho": "LS",
  "Liberia": "LR",
  "Libya": "LY",
  "Liechtenstein": "LI",
  "Lithuania": "LT",
  "Luxembourg": "LU",
  "Madagascar": "MG",
  "Malawi": "MW",
  "Malaysia": "MY",
  "Maldives": "MV",
  "Mali": "ML",
  "Malta": "MT",
  "Marshall Islands": "MH",
  "Mauritania": "MR",
  "Mauritius": "MU",
  "Mexico": "MX",
  "Micronesia": "FM",
  "Moldova": "MD",
  "Monaco": "MC",
  "Mongolia": "MN",
  "Montenegro": "ME",
  "Morocco": "MA",
  "Mozambique": "MZ",
  "Myanmar": "MM",
  "Namibia": "NA",
  "Nauru": "NR",
  "Nepal": "NP",
  "Netherlands": "NL",
  "New Zealand": "NZ",
  "Nicaragua": "NI",
  "Niger": "NE",
  "Nigeria": "NG",
  "North Macedonia": "MK",
  "Norway": "NO",
  "Oman": "OM",
  "Pakistan": "PK",
  "Palau": "PW",
  "Panama": "PA",
  "Papua New Guinea": "PG",
  "Paraguay": "PY",
  "Peru": "PE",
  "Philippines": "PH",
  "Poland": "PL",
  "Portugal": "PT",
  "Qatar": "QA",
  "Romania": "RO",
  "Russia": "RU",
  "Rwanda": "RW",
  "Saint Kitts and Nevis": "KN",
  "Saint Lucia": "LC",
  "Saint Vincent and the Grenadines": "VC",
  "Samoa": "WS",
  "San Marino": "SM",
  "Sao Tome and Principe": "ST",
  "Saudi Arabia": "SA",
  "Senegal": "SN",
  "Serbia": "RS",
  "Seychelles": "SC",
  "Sierra Leone": "SL",
  "Singapore": "SG",
  "Slovakia": "SK",
  "Slovenia": "SI",
  "Solomon Islands": "SB",
  "Somalia": "SO",
  "South Africa": "ZA",
  "South Korea": "KR",
  "South Sudan": "SS",
  "Spain": "ES",
  "Sri Lanka": "LK",
  "Sudan": "SD",
  "Suriname": "SR",
  "Sweden": "SE",
  "Switzerland": "CH",
  "Syria": "SY",
  "Taiwan": "TW",
  "Tajikistan": "TJ",
  "Tanzania": "TZ",
  "Thailand": "TH",
  "Timor-Leste": "TL",
  "Togo": "TG",
  "Tonga": "TO",
  "Trinidad and Tobago": "TT",
  "Tunisia": "TN",
  "Turkey": "TR",
  "Turkmenistan": "TM",
  "Tuvalu": "TV",
  "Uganda": "UG",
  "Ukraine": "UA",
  "United Arab Emirates": "AE",
  "United Kingdom": "GB",
  "United States": "US",
  "Uruguay": "UY",
  "Uzbekistan": "UZ",
  "Vanuatu": "VU",
  "Venezuela": "VE",
  "Vietnam": "VN",
  "Yemen": "YE",
  "Zambia": "ZM",
  "Zimbabwe": "ZW"
};
const String english = 'en';
const String spanish = 'es';
const String hindi = 'hi';
const String bengali = 'bn';
const String telugu = 'te';
const String tamil = 'ta';
const String urdu = 'ur';
const String gujarati = 'gu';
const String kannada = 'kn';
const String oriya = 'or';
const String malayalam = 'ml';
const String punjabi = 'pa';
const String assamese = 'as';
const String marathi = 'mr';
const String nepali = 'ne';
const String sinhala = 'si';

Locale getLocaleFromCode(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, 'US');
    case spanish:
      return const Locale(spanish, 'ES');
    case hindi:
      return const Locale(hindi, 'IN');
    case bengali:
      return const Locale(bengali, 'IN');
    case telugu:
      return const Locale(telugu, 'IN');
    case tamil:
      return const Locale(tamil, 'IN');
    case urdu:
      return const Locale(urdu, 'IN');
    case gujarati:
      return const Locale(gujarati, 'IN');
    case kannada:
      return const Locale(kannada, 'IN');
    case oriya:
      return const Locale(oriya, 'IN');
    case malayalam:
      return const Locale(malayalam, 'IN');
    case punjabi:
      return const Locale(punjabi, 'IN');
    case assamese:
      return const Locale(assamese, 'IN');
    case marathi:
      return const Locale(marathi, 'IN');
    case nepali:
      return const Locale(nepali, 'IN');
    case sinhala:
      return const Locale(sinhala, 'IN');
    default:
      return const Locale(english, 'US');
  }
}

String getLanguageCode(String language) {
  switch (language) {
    case 'English':
      return english;
    case 'Spanish':
      return spanish;
    case 'Hindi':
      return hindi;
    case 'Bengali':
      return bengali;
    case 'Telugu':
      return telugu;
    case 'Tamil':
      return tamil;
    case 'Urdu':
      return urdu;
    case 'Gujarati':
      return gujarati;
    case 'Kannada':
      return kannada;
    case 'Oriya':
      return oriya;
    case 'Malayalam':
      return malayalam;
    case 'Punjabi':
      return punjabi;
    case 'Assamese':
      return assamese;
    case 'Marathi':
      return marathi;
    case 'Nepali':
      return nepali;
    case 'Sinhala':
      return sinhala;
    default:
      return english;
  }
}

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
