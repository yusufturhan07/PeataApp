import 'package:flutter/material.dart';
import 'package:mvc_uygun_peata_proje/models/mypet_model.dart';
import 'package:mvc_uygun_peata_proje/models/user_model.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileController extends ChangeNotifier {
  UserModel _user =
      UserModel(email: '', displayName: '', userID: '', userToken: '');
  List<PetModel> _petList = [];

  UserModel get user => _user;
  List<PetModel> get petList => _petList;

  ProfileController() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? 'Not Found';
    String displayName = prefs.getString('displayName') ?? 'Not Found';
    String userID = prefs.getString('userID') ?? 'Not Found';
    String userToken = prefs.getString('userToken') ?? 'Not Found';

    _user = UserModel(
        email: email,
        displayName: displayName,
        userID: userID,
        userToken: userToken);
    notifyListeners();
    await fetchPetList();
  }

  Future<void> fetchPetList() async {
    final response = await http.post(
      Uri.parse('$ipAddress:$portName/postPetListByUserId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _user.userToken,
      },
      body: jsonEncode({'userid': _user.userID}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      _petList = data.map((item) => PetModel.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load pet list');
    }
  }

  Future<void> deleteAd(String adId) async {
    final response = await http.post(
      Uri.parse('$ipAddress:$portName/deleteAd'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _user.userToken,
      },
      body: jsonEncode({'ad_id': adId}),
    );

    if (response.statusCode == 200) {
      _petList.removeWhere((pet) => pet.adId == adId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete ad');
    }
  }
}
