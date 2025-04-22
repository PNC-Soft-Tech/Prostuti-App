import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/model_test_details_controller.dart';

class ModelTestAccessBottomSheet extends GetWidget<ModelTestDetailsController> {
  final String modelTestId;

  const ModelTestAccessBottomSheet({super.key, required this.modelTestId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Access Mode',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTestModeCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Read Mode',
                    description: 'Detailed learning',
                    color: AppColors.primary,
                    // onTap: () => _navigateToReadMode(),
                    onTap: () {
                      // Get.find<ModelTestDetailsController>().currentSelectedModelTestId.value = modelTestId;
                      //  Get.find<ModelTestDetailsController>().currentSelectedModelTestMode.value = 'read';
                      Get.toNamed(Routes.modelTestDetails, arguments: {
                        'modelTestId': modelTestId,
                        'mode': 'read',
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTestModeCard(
                    icon: Icons.quiz_rounded,
                    title: 'Exam Mode',
                    description: 'Timed practice test',
                    color: AppColors.primary,
                    // onTap: () => _navigateToExamMode(),
                    onTap: () {
                      //    Get.find<ModelTestDetailsController>().currentSelectedModelTestId.value = modelTestId;
                      //  Get.find<ModelTestDetailsController>().currentSelectedModelTestMode.value = 'exam';
                      Get.toNamed(Routes.modelTestDetails, arguments: {
                        'modelTestId': modelTestId,
                        'mode': 'exam',
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     // color: Colors.grey.withOpacity(0.2),
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 40,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation methods for each mode
  void _navigateToReadMode() {
    Get.to(() => const ReadModeDetailScreen());
  }

  void _navigateToExamMode() {
    Get.to(() => const ExamModeDetailScreen());
  }
}

// Read Mode Detail Screen
class ReadModeDetailScreen extends StatelessWidget {
  const ReadModeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Mode'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Read Mode Activated',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Explore detailed content, review materials, and learn at your own pace.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exam Mode Detail Screen
class ExamModeDetailScreen extends StatelessWidget {
  const ExamModeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Mode'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_rounded,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Exam Mode Activated',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Start a timed practice test with strict exam-like conditions and performance tracking.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
