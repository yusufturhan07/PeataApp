import 'package:flutter/material.dart';

class AdoptionDetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String image;

  const AdoptionDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // App bar'da adı göster
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
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
                    return const Text('😢');
                  },
                ),
              ),
            ),
            // Açıklama
            Text(description),
          ],
        ),
      ),
    );
  }
}
