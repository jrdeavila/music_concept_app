import 'package:flutter/material.dart';

class NoWifiCoonnectionPage extends StatelessWidget {
  const NoWifiCoonnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotWifiPage'),
      ),
      body: const Center(
        child: Text('Scaffold Body'),
      ),
    );
  }
}
