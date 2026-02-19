import 'package:flutter/material.dart';

class CensusScreen extends StatelessWidget {
  const CensusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIU Guardian - Censo'),
      ),
      body: const Center(
        child: Text('Formulario de Censo aquí'),
      ),
    );
  }
}
