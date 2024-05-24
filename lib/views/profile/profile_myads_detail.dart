import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';

import 'package:http/http.dart' as http;

class ProfileMyAdsDetail extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final String ad_id;
  final String userToken; // ProfileMyAdsDetail

  ProfileMyAdsDetail({
    required this.name,
    required this.description,
    required this.image,
    required this.ad_id,
    required this.userToken,
  });
  Future<void> _onDeleteAd(BuildContext context) async {
    await http.post(
      Uri.parse('$ipAddress:$portName/deleteAdoption'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
      },
      body: jsonEncode(<String, String>{
        'ad_id': ad_id,
      }),
    );

    Navigator.pop(context);
    print('Adoption deleted  $ad_id'); // Önceki sayfaya dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Display the name in the app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 30),
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Image.network(
                  image,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('ð¢');
                  },
                ),
              ),
            ),
            // Description
            Text(description),

            ElevatedButton(
                onPressed: () => _onDeleteAd(context), child: Text('Sil')),
          ],
        ),
      ),
    );
  }
}
