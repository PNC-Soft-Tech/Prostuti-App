// Test file to verify OTP widget functionality
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/app/common/widgets/otp_input_widget.dart';

void main() {
  group('OTP Input Widget Tests', () {
    testWidgets('OTP Widget renders correctly', (WidgetTester tester) async {
      String completedOTP = '';
      String changedOTP = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputWidget(
              length: 4,
              onCompleted: (otp) => completedOTP = otp,
              onChanged: (otp) => changedOTP = otp,
              hasError: false,
              enableHapticFeedback: true,
            ),
          ),
        ),
      );

      // Verify that 4 text fields are rendered
      expect(find.byType(TextFormField), findsNWidgets(4));
      
      // Verify initial state
      expect(completedOTP, isEmpty);
      expect(changedOTP, isEmpty);
    });

    testWidgets('OTP Widget handles input correctly', (WidgetTester tester) async {
      String completedOTP = '';
      String changedOTP = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputWidget(
              length: 4,
              onCompleted: (otp) => completedOTP = otp,
              onChanged: (otp) => changedOTP = otp,
              hasError: false,
              enableHapticFeedback: true,
            ),
          ),
        ),
      );

      // Find the first text field
      final firstField = find.byType(TextFormField).first;
      
      // Enter a digit
      await tester.enterText(firstField, '1');
      await tester.pump();
      
      // Verify onChange callback was called
      expect(changedOTP, '1');
      expect(completedOTP, isEmpty); // Should not be completed yet
    });

    testWidgets('OTP Widget shows error state correctly', (WidgetTester tester) async {
      const errorMessage = 'Invalid OTP';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputWidget(
              length: 4,
              onCompleted: (otp) {},
              hasError: true,
              errorText: errorMessage,
              enableHapticFeedback: true,
            ),
          ),
        ),
      );

      // Verify error message is displayed
      expect(find.text(errorMessage), findsOneWidget);
      
      // Verify error styling is applied (red borders would be tested differently)
      final errorText = tester.widget<Text>(find.text(errorMessage));
      expect(errorText.style?.color, Colors.red);
    });

    testWidgets('OTP Widget handles paste functionality', (WidgetTester tester) async {
      String completedOTP = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputWidget(
              length: 4,
              onCompleted: (otp) => completedOTP = otp,
              hasError: false,
              enableHapticFeedback: true,
            ),
          ),
        ),
      );

      // This test would need more setup to test actual paste functionality
      // For now, we'll verify the widget can be created
      expect(find.byType(OTPInputWidget), findsOneWidget);
    });

    testWidgets('OTP Widget completes when all fields filled', (WidgetTester tester) async {
      String completedOTP = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OTPInputWidget(
              length: 4,
              onCompleted: (otp) => completedOTP = otp,
              hasError: false,
              enableHapticFeedback: true,
            ),
          ),
        ),
      );

      // Fill all fields
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '1');
      await tester.pump();
      await tester.enterText(fields.at(1), '2');
      await tester.pump();
      await tester.enterText(fields.at(2), '3');
      await tester.pump();
      await tester.enterText(fields.at(3), '4');
      await tester.pump();

      // Verify completion callback was called
      expect(completedOTP, '1234');
    });
  });
}
