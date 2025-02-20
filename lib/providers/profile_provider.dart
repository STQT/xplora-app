import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;


class ProfileProvider extends ChangeNotifier {
  // Step 1 (Basic Info)
  String _firstName = "";
  String _lastName = "";
  String _dob = "";
  String? _gender;

  // Step 2 (Interests & Languages)
  List<String> _selectedInterests = [];
  List<String> _selectedLanguages = [];

  // Step 3 (Location)
  int? _selectedCountryId;
  int? _selectedCityId;
  String? _selectedCountry;
  String? _selectedCity;
  String _fromDate = "";
  String _toDate = "";

  // API Data
  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _cities = [];
  List<String> _interests = [];
  List<String> _languages = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Getters
  String get firstName => _firstName;

  String get lastName => _lastName;

  String get dob => _dob;

  String? get gender => _gender;

  List<String> get selectedInterests => _selectedInterests;

  List<String> get selectedLanguages => _selectedLanguages;

  String? get selectedCountry => _selectedCountry;

  String? get selectedCity => _selectedCity;

  String get fromDate => _fromDate;

  String get toDate => _toDate;

  List<Map<String, dynamic>> get countries => _countries;

  List<Map<String, dynamic>> get cities => _cities;

  List<String> get interests => _interests;

  List<String> get languages => _languages;

  File? _profileImage; // Новое поле для фото

  File? get profileImage => _profileImage;

  /// **Step 1: Save Basic Profile Info**
  void updateProfileStep1({
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _dob = dob;
    _gender = gender;
    notifyListeners();
  }

  void updateProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  /// **Step 2: Save Interests & Languages**
  void updateProfileStep2({
    required List<String> interests,
    required List<String> languages,
  }) {
    _selectedInterests = interests;
    _selectedLanguages = languages;
    notifyListeners();
  }

  /// **Step 3: Save Country, City, and Dates**
  void updateProfileStep3({
    required String country,
    required int countryId,
    required String city,
    required int cityId,
    required String fromDate,
    required String toDate,
  }) {
    _selectedCountry = country;
    _selectedCountryId = countryId;
    _selectedCity = city;
    _selectedCityId = cityId;
    _fromDate = fromDate;
    _toDate = toDate;
    notifyListeners();
  }

  /// **Fetch Countries and Cities from API**
  Future<void> fetchCountriesAndCities() async {
    _isLoading = true;
    notifyListeners();

    try {
      final countryResponse = await http
          .get(Uri.parse("https://xplora.robosoft.kz/api/common/countries/"));
      final cityResponse = await http
          .get(Uri.parse("https://xplora.robosoft.kz/api/common/cities/"));

      if (countryResponse.statusCode == 200 && cityResponse.statusCode == 200) {
        final countryData = jsonDecode(countryResponse.body);
        final cityData = jsonDecode(cityResponse.body);

        _countries = List<Map<String, dynamic>>.from(countryData['results']);
        _cities = List<Map<String, dynamic>>.from(cityData['results']);
      }
    } catch (error) {
      print("Error fetching countries and cities: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Fetch Interests and Languages from API**
  Future<void> fetchInterestsAndLanguages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final interestResponse = await http
          .get(Uri.parse("https://xplora.robosoft.kz/api/common/interests/"));
      final languageResponse = await http
          .get(Uri.parse("https://xplora.robosoft.kz/api/common/languages/"));

      if (interestResponse.statusCode == 200 &&
          languageResponse.statusCode == 200) {
        final interestData = jsonDecode(interestResponse.body);
        final languageData = jsonDecode(languageResponse.body);

        _interests = List<String>.from(
          interestData['results'].map<String>((item) => item['name'] as String),
        );

        _languages = List<String>.from(
          languageData['results'].map<String>((item) => item['name'] as String),
        );
      }
    } catch (error) {
      print("Error fetching interests and languages: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Get Cities by Country ID**
  List<Map<String, dynamic>> getCitiesByCountry(int countryId) {
    return _cities.where((city) => city['country_id'] == countryId).toList();
  }

  String _formatDate(String date) {
    try {
      List<String> parts = date.split('.');
      return "${parts[2]}-${parts[1]}-${parts[0]}"; // Convert DD.MM.YYYY -> YYYY-MM-DD
    } catch (e) {
      return date; // Return as is if there's an error
    }
  }

  Future<void> saveProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print("Error: No auth token found!");
        return;
      }

      // Создаём Multipart-запрос
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://xplora.robosoft.kz/api/users/profiles/"),
      );

      // Добавляем заголовок авторизации
      request.headers["Authorization"] = "Bearer $token";

      // Добавляем текстовые поля
      request.fields["firstname"] = _firstName;
      request.fields["lastname"] = _lastName;
      request.fields["gender"] = _gender?.toLowerCase() ?? "";
      request.fields["birth_date"] = _formatDate(_dob);
      request.fields["bio"] = "This is my bio"; // Убедитесь, что bio не пустой
      request.fields["interest_ids"] = _selectedInterests.isNotEmpty
          ? _selectedInterests.join(",")
          : "1";
      request.fields["language_ids"] = _selectedLanguages.isNotEmpty
          ? _selectedLanguages.join(",")
          : "1";
      request.fields["city_id"] = (_selectedCityId ?? 1).toString();
      request.fields["date_start"] = _formatDate(_fromDate);
      request.fields["date_end"] = _formatDate(_toDate);

      // Если изображение выбрано, добавляем его в запрос как файл
      if (_profileImage != null) {
        var stream = http.ByteStream(_profileImage!.openRead());
        var length = await _profileImage!.length();
        var multipartFile = http.MultipartFile(
          "profile_img", // имя поля должно совпадать с ожидаемым на сервере
          stream,
          length,
          filename: path.basename(_profileImage!.path),
        );
        request.files.add(multipartFile);
      }

      // Отправляем запрос
      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Profile successfully created!");
      } else {
        String responseData = await response.stream.bytesToString();
        print("Error saving profile: $responseData");
      }
    } catch (error) {
      print("Error saving profile: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
