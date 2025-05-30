import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../models/job-circulars-model.dart';

class JobCircularController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var jobCirculars = <JobCircular>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndLoadJobCirculars();
  }
  void _checkAuthAndLoadJobCirculars() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'job circulars',
      customMessage: 'Please log in to view job circulars',
    );
    
    if (hasAccess) {
      fetchJobCirculars();
    }
  }
  void fetchJobCirculars() async {
    isLoading(true);
    final result = await _apiHelper.fetchJobCirculars();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (data) {
        jobCirculars.assignAll(data);
      },
    );
    isLoading(false);
  }
}
