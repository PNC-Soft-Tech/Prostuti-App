// Integration test for Model Tests List feature
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'lib/app/modules/model-tests-list/controller/model_tests_list_controller.dart';
import 'lib/app/modules/model-tests-list/binding/model_tests_list_binding.dart';
import 'lib/app/routes/app_pages.dart';

void main() {
  group('Model Tests List Integration Tests', () {
    setUp(() {
      // Initialize GetX
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('Routes configuration should include modelTestsList', () {
      // Test that the route is properly configured
      expect(Routes.modelTestsList, equals('/model-tests-list'));
      
      // Find the route configuration
      final modelTestsRoute = AppPages.routes.firstWhere(
        (route) => route.name == Routes.modelTestsList,
        orElse: () => throw Exception('Route not found'),
      );
      
      expect(modelTestsRoute.name, equals(Routes.modelTestsList));
      expect(modelTestsRoute.binding, isA<ModelTestsListBinding>());
    });

    test('ModelTestsListController should initialize properly', () {
      // Test controller initialization
      final controller = ModelTestsListController();
      
      expect(controller.isLoading.value, isFalse);
      expect(controller.modelTests.isEmpty, isTrue);
      expect(controller.currentPage.value, equals(1));
      expect(controller.selectedFilter.value, equals('All'));
      expect(controller.filterOptions.length, greaterThan(0));
    });

    test('Controller should handle filter options correctly', () {
      final controller = ModelTestsListController();
      
      expect(controller.filterOptions, contains('All'));
      expect(controller.filterOptions, contains('Recent'));
      expect(controller.filterOptions, contains('Most Questions'));
      expect(controller.filterOptions, contains('Highest Marks'));
      expect(controller.filterOptions, contains('BCS Tests'));
    });
  });
}
