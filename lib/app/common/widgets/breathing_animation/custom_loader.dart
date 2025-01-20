import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'breathing_loading_animation.dart'; // Import your animation widget

class CustomLoader {
  static final _overlayEntry =
      Rx<OverlayEntry?>(null); // Observable for reactive control

  static void show() {
    if (_overlayEntry.value != null) return; // Prevent multiple overlays
    _overlayEntry.value = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Dimmed background
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Breath animation
          const BreathLoadingAnimation(),
        ],
      ),
    );

    // Insert overlay if context is available
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      Overlay.of(overlayContext).insert(_overlayEntry.value!);
    }
  }

  static void hide() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}
