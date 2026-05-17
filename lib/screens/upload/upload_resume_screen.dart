import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class UploadResumeScreen extends StatelessWidget {
  const UploadResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Upload Screen\nComing in Phase 4',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}