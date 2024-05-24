// controllers/home_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_uygun_peata_proje/models/adoption_model.dart';
import 'package:mvc_uygun_peata_proje/models/user_model.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdoptionController extends ChangeNotifier {
  UserModel _user =
      UserModel(email: '', displayName: '', userID: '', userToken: '');
  List<AdoptionItem> _adoptionItems = [];
  List<String> _citiesToFilter = ['Antalya', 'İstanbul', 'Ankara'];
  String _selectedCity = 'All';

  UserModel get user => _user;
  List<AdoptionItem> get adoptionItems => _adoptionItems;
  List<String> get citiesToFilter => _citiesToFilter;
  String get selectedCity => _selectedCity;

  AdoptionController() {
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? 'Gelemedi';
    String userToken = prefs.getString('userToken') ?? 'Gelemedi';
    String userID = prefs.getString('userID') ?? 'Gelemedi';
    String displayName = prefs.getString('displayName') ?? 'Gelemedi';
    _user = UserModel(
        email: email,
        displayName: displayName,
        userID: userID,
        userToken: userToken);

    notifyListeners();
    await fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.get(
      Uri.parse('$ipAddress:$portName/getAdoptionList'),
      headers: <String, String>{
        'Authorization': _user.userToken,
      }, // The user token is sent as a header parameter  },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      _adoptionItems = data.map((item) => AdoptionItem.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void setSelectedCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  bool shouldDisplayCity(String city) {
    return _selectedCity == 'All' || city == _selectedCity;
  }
}
