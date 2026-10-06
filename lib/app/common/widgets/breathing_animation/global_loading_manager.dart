import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'breathing_loading_animation.dart';

class GlobalLoadingManager {
  static final GlobalLoadingManager _instance = GlobalLoadingManager._internal();
  static GlobalLoadingManager get instance => _instance;

  GlobalLoadingManager._internal();

  OverlayEntry? _overlayEntry;
  String _currentMessage = 'Loading...';

  /// Show loading with a specific message
  void show({String message = 'Loading...'}) {
    _currentMessage = message;
    
    if (_overlayEntry != null) {
      hide(); // Remove existing overlay first
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildLoadingOverlay(),
    );

    // Use maybeOf so we no-op (instead of crashing) when the current route
    // doesn't sit under an Overlay ancestor. Callers should provide their own
    // inline loading state in that case.
    final overlayContext = Get.overlayContext;
    final overlay =
        overlayContext != null ? Overlay.maybeOf(overlayContext) : null;
    if (overlay != null) {
      overlay.insert(_overlayEntry!);
    } else {
      _overlayEntry = null;
    }
  }

  /// Hide the loading overlay
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Update the message while loading is visible
  void updateMessage(String message) {
    _currentMessage = message;
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  /// Show loading during a Future operation
  Future<T> showDuring<T>(
    Future<T> future, {
    String message = 'Loading...',
  }) async {
    show(message: message);
    try {
      final result = await future;
      hide();
      return result;
    } catch (e) {
      hide();
      rethrow;
    }
  }

  /// Show loading during an async operation (alternative method name for compatibility)
  Future<void> showDuringAsync(Future<void> Function() operation, {
    String message = 'Loading...',
  }) async {
    show(message: message);
    try {
      await operation();
      hide();
    } catch (e) {
      hide();
      rethrow;
    }
  }

  /// Show loading for navigation with auto-hide after a short delay
  void showForNavigation({String message = 'Navigating...'}) {
    show(message: message);
    // Auto-hide after a brief moment to allow navigation to complete
    Future.delayed(const Duration(milliseconds: 800), () {
      hide();
    });
  }

  Widget _buildLoadingOverlay() {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BreathLoadingAnimation(),
                const SizedBox(height: 16),
                Text(
                  _currentMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
