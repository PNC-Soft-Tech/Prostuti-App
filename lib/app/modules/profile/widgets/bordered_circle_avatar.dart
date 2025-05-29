import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../controllers/profile_controller.dart';

class BorderedCircleAvatar extends GetView<ProfileController> {
  const BorderedCircleAvatar({super.key});
    @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Debug log for profile image URL
      final profilePicUrl = controller.userProfile.value?.profilePic;
      print("DEBUG: Profile Image URL in BorderedCircleAvatar: $profilePicUrl");
        // Store local copy of loading state
      final bool isLoading = controller.isLoadingProfilePic.value;
      print("DEBUG: BorderedCircleAvatar - isLoading state: $isLoading");
      
      // Log current profileImageUrl and userProfile.profilePic values
      print("DEBUG: BorderedCircleAvatar - controller.profileImageUrl.value: '${controller.profileImageUrl.value}'");
      print("DEBUG: BorderedCircleAvatar - controller.userProfile.value?.profilePic: '${controller.userProfile.value?.profilePic}'");
      
      // Get a valid image URL using our helper function
      final imageUrl = controller.getValidProfileImageUrl();
      print("DEBUG: BorderedCircleAvatar - Using validated image URL: '$imageUrl'");
      
      // Log the fully constructed URL we'll use (for easier debugging)
      final cacheKey = "$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}";
      print("DEBUG: BorderedCircleAvatar - Final image URL with cache busting: '$cacheKey'");return Center(
        child: isLoading == true
            ? CupertinoActivityIndicator(color: AppColors.primary)
            : imageUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 50.w,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Builder(
                        builder: (context) {                          print("DEBUG: BorderedCircleAvatar - Attempting to load image from URL: '$imageUrl'");
                          
                          // Check if URL is HTTPS - preferred for security and better caching behavior
                          if (imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
                            print("WARNING: BorderedCircleAvatar - Using HTTP URL instead of HTTPS: '$imageUrl'");
                            // We'll continue with HTTP but log the warning
                          }
                          
                          // Add cache key with random value to avoid any caching issues
                          final timestamp = DateTime.now().millisecondsSinceEpoch;
                          final random = timestamp % 10000; // Add some randomness
                          final cacheKey = "$imageUrl?v=$timestamp&r=$random";
                          print("DEBUG: BorderedCircleAvatar - Using cache key: '$cacheKey'");
                          
                          return Image.network(
                            cacheKey,
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            
                            // Set explicit caching options
                            cacheWidth: 300, // Cache at reasonable resolution
                            cacheHeight: 300,
                            
                            // Add HTTP headers to avoid caching issues
                            headers: {
                              "Cache-Control": "no-cache",
                              "Pragma": "no-cache",
                              "Expires": "0",
                            },
                            
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                print("DEBUG: Profile image loaded successfully from: '$imageUrl'");
                                return child;
                              }
                              print("DEBUG: Profile image loading from '$imageUrl': ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes ?? 'unknown total'}");
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },                            errorBuilder: (context, error, stackTrace) {
                              print("ERROR: BorderedCircleAvatar - Loading profile image from '$imageUrl' failed: $error");
                              print("ERROR: BorderedCircleAvatar - Stack trace: $stackTrace");
                              
                              // Log network error details
                              if (error.toString().contains('SocketException')) {
                                print("ERROR: BorderedCircleAvatar - Network connectivity issue detected");
                              } else if (error.toString().contains('404')) {
                                print("ERROR: BorderedCircleAvatar - Image not found (404) at URL: '$imageUrl'");
                              } else if (error.toString().contains('HandshakeException')) {
                                print("ERROR: BorderedCircleAvatar - SSL/TLS handshake failed for URL: '$imageUrl'");
                              }
                              
                              // Try with different variants
                              print("DEBUG: BorderedCircleAvatar - Trying alternative URL formats");
                              
                              // First try without cache busting
                              if (cacheKey != imageUrl) {
                                print("DEBUG: BorderedCircleAvatar - Retrying with direct URL: '$imageUrl'");
                                return Image.network(
                                  imageUrl,
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("ERROR: BorderedCircleAvatar - Second attempt failed: $error");
                                    
                                    // If HTTP and not HTTPS, try switching to HTTPS
                                    if (imageUrl.startsWith('http://')) {
                                      final httpsUrl = imageUrl.replaceFirst('http://', 'https://');
                                      print("DEBUG: BorderedCircleAvatar - Attempting with HTTPS: '$httpsUrl'");
                                      
                                      return Image.network(
                                        httpsUrl,
                                        width: 100.w,
                                        height: 100.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          print("ERROR: BorderedCircleAvatar - HTTPS attempt failed: $error");
                                          return SvgPicture.asset(
                                            "assets/default-male.svg",
                                            width: 70.w,
                                            height: 70.h,
                                          );
                                        },
                                      );
                                    }
                                    
                                    return SvgPicture.asset(
                                      "assets/default-male.svg",
                                      width: 70.w,
                                      height: 70.h,
                                    );
                                  },
                                );
                              }
                              
                              return SvgPicture.asset(
                                "assets/default-male.svg",
                                width: 70.w,
                                height: 70.h,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50.w,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(
                        "assets/default-male.svg",
                        width: 70.w,
                        height: 70.h,
                      ),
                    ),
                  ),
      );
    });
  }
}