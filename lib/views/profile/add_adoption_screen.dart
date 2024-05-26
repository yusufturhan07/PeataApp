import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mvc_uygun_peata_proje/main.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddAdoptionPage extends StatefulWidget {
  const AddAdoptionPage({super.key});

  @override
  _AddAdoptionPageState createState() => _AddAdoptionPageState();
}

class _AddAdoptionPageState extends State<AddAdoptionPage> {
  final TextEditingController _textFieldControllerAddress =
      TextEditingController();

  final TextEditingController _textFieldControllerAge = TextEditingController();
  final TextEditingController _textFieldControllerBreed =
      TextEditingController();
  final TextEditingController _textFieldControllerDescription =
      TextEditingController();
  final TextEditingController _textFieldControllerName =
      TextEditingController();
  final TextEditingController _textFieldControllerType =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfos();
  }

  bool _isSubmitting = false;
  bool _isSuccess = false;
  File? _selectedImage;
  String imageResponseUrl = '';
  String imageUrl = '$ipAddress:$portName/upload';
  String _userToken = '';

  String _userId = '';

  List<String> _cities = ['Ankara', 'Antalya', 'İstanbul'];

  final Map<String, List<String>> _neighborhoods = {
    'Ankara': ['Çankaya', 'Keçiören', 'Mamak'],
    'Antalya': ['Muratpaşa', 'Konyaaltı', 'Kepez'],
    'İstanbul': ['Beşiktaş', 'Kadıköy', 'Üsküdar']
  };

  String? _selectedCity; // Variable to hold the selected city
  String? _selectedNeighborhood; // Variable to hold the selected neighborhood
  String? _selectedGender; // variable to hold the selected gender
  String? _selectedType; // variable to hold the selected type

  Future<void> _getUserInfos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userID') ?? 'Not Found';
    String userToken = prefs.getString('userToken') ?? 'Not Found';

    setState(() {
      _userId = userId;
      _userToken = userToken;
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    // URL for text fields API
    String textFieldUrl = '$ipAddress:$portName/saveAdoption';
    // URL for image file API
    // String imageUrl = '$ipAddress:$portName/upload';

    Map<String, String> textFieldBody = {
      'userid': _userId,
      'address': _textFieldControllerAddress.text,
      'city': _selectedCity ?? '', // Use the selected city
      'neighborhood':
          _selectedNeighborhood ?? '', // Use the selected neighborhood
      'age': _textFieldControllerAge.text,
      'breed': _textFieldControllerBreed.text,
      'description': _textFieldControllerDescription.text,
      'name': _textFieldControllerName.text,
      'gender': _selectedGender ?? '', // Use the selected gender
      'type': _textFieldControllerType.text,
      'image': imageResponseUrl,
    };

    try {
      // Send text fields data to the first API
      final textFieldResponse = await http.post(Uri.parse(textFieldUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                _userToken, // Send the user token in the header of the request
          },
          body: jsonEncode(textFieldBody));

      // Handle the response from text fields API
      print('Text Field Response: ${textFieldResponse.body}');

      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });

      // Show success alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Form submitted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyApp()), //// pop da koyabilirsin dikkat et
                  ); // Close the alert dialog
                  // Go back to the previous page
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle any errors that occur during the API request
      print('Error: $error');

      setState(() {
        _isSubmitting = false;
        _isSuccess = false;
      });
    }
    print('Text Field Body: $textFieldBody');
  }

  Future<String> _sendImageToApi(String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['userid'] = _userId;
    var pic = await http.MultipartFile.fromPath("image", _selectedImage!.path,
        contentType: MediaType('image', 'jpeg'));
    request.files.add(pic);
    var response = await request.send();

    return await response.stream.bytesToString();
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    if (_selectedImage != null) {
      var imageResponse = await _sendImageToApi(imageUrl);
      var imageResponseJson = json.decode(imageResponse);
      imageResponseUrl = imageResponseJson['imageUrl'];
    }
  }

  Future<void> _getPredict(BuildContext context) async {
    final String apiUrl = '$ipAddress:3000/AIPredict';

    print('Image Response URL: $imageResponseUrl');

    final Map<String, String> postData = {
      'imageLink': imageResponseUrl,
    };
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(postData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    final String predictionName = responseData['prediction'];
    print('Response Data:    $imageResponseUrl');
    print('Prediction   :    $predictionName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPeataYesili.withOpacity(0.9),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Adoption',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: _cities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city,
                              style: TextStyle(color: colorPeataYesili)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                    _selectedNeighborhood =
                        null; // Reset the selected neighborhood when the city changes
                  });
                },
                decoration: inputDecorationAddAd('City'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedNeighborhood,
                items: (_selectedCity != null
                        ? _neighborhoods[_selectedCity]!
                        : <String>[])
                    .map((neighborhood) => DropdownMenuItem(
                          value: neighborhood,
                          child: Text(neighborhood,
                              style: TextStyle(color: colorPeataYesili)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedNeighborhood = value;
                  });
                },
                decoration: inputDecorationAddAd('Neighborhood'),
              ),
              TextField(
                controller: _textFieldControllerAddress,
                decoration: inputDecorationAddAd('Address'),
              ),
              TextField(
                controller: _textFieldControllerName,
                decoration: inputDecorationAddAd('Name'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['Dog', 'Cat']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type,
                              style: TextStyle(color: colorPeataYesili)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                decoration: inputDecorationAddAd('Type'),
                icon: Icon(Icons.arrow_drop_down, color: colorPeataYesili),
              ),
              TextField(
                controller: _textFieldControllerAge,
                decoration: inputDecorationAddAd('Age'),
              ),
              TextField(
                controller: _textFieldControllerBreed,
                decoration: inputDecorationAddAd('Breed'),
              ),
              TextField(
                controller: _textFieldControllerDescription,
                decoration: inputDecorationAddAd('Description'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender,
                              style: TextStyle(color: colorPeataYesili)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                decoration: inputDecorationAddAd('Gender'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorPeataYesili),
                ),
                onPressed: _getImageFromGallery,
                child: textButton("Select Image"),
              ),
              const SizedBox(height: 16.0),
              _selectedImage != null
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorPeataYesili),
                      ),
                      onPressed: () => _getPredict(context),
                      child: textButton('Yapay Zeka'),
                    )
                  : const SizedBox(),
              const SizedBox(height: 16.0),
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 100,
                    )
                  : const SizedBox(
                      height: 30,
                    ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorPeataYesili),
                ),
                onPressed: (_selectedImage == null) || (_selectedType == null)
                    ? null
                    : (_isSubmitting ? null : _submitForm),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : textButton('Submit'),
              ),
              const SizedBox(height: 16.0),
              _isSuccess
                  ? const Text(
                      'Form submitted successfully!',
                      style: TextStyle(color: Colors.green),
                    )
                  : const SizedBox(),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Text textButton(String txt) =>
      Text(txt, style: const TextStyle(color: Colors.white, fontSize: 20));

  InputDecoration inputDecorationAddAd(String textName) => InputDecoration(
        labelText: (textName),
        focusColor: Colors.green,
        labelStyle: TextStyle(color: colorPeataYesili.withOpacity(0.9)),
      );
}
