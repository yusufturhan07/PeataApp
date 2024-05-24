import 'package:flutter/material.dart';

class AddAdoptionPage extends StatelessWidget {
  const AddAdoptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Adoption Ad'),
      ),
      body: const Center(
        child: Text('Add Adoption Ad Form Here'),
      ),
    );
  }
}
