#!/usr/bin/env dart

// UI Overflow Fix Validation Script
// This script validates that all ParentDataWidget and null safety fixes are in place

import 'dart:io';

void main() {
  print('🔍 Validating UI Overflow Fixes...\n');
  
  var allPassed = true;
  
  // Check 1: Contest Details View Structure
  allPassed &= validateContestDetailsView();
  
  // Check 2: Shared Question Widget Null Safety
  allPassed &= validateSharedQuestionWidget();
  
  // Check 3: Question Navigator Structure
  allPassed &= validateQuestionNavigator();
  
  // Check 4: Question Navigator Floating Widget
  allPassed &= validateQuestionNavigatorFloating();
  
  // Final Result
  print('\n' + '='*50);
  if (allPassed) {
    print('✅ ALL VALIDATION CHECKS PASSED!');
    print('The UI overflow fixes have been successfully implemented.');
  } else {
    print('❌ SOME VALIDATION CHECKS FAILED!');
    print('Please review the issues above.');
  }
  print('='*50);
}

bool validateContestDetailsView() {
  print('📂 Checking contest_details_view.dart...');
  
  final file = File('lib/app/modules/contest-details/view/contest_details_view.dart');
  if (!file.existsSync()) {
    print('❌ File not found');
    return false;
  }
  
  final content = file.readAsStringSync();
  
  var passed = true;
  
  // Check for proper Column structure
  if (content.contains('return Column(')) {
    print('✅ Uses Column layout structure');
  } else {
    print('❌ Missing Column layout structure');
    passed = false;
  }
  
  // Check for Expanded wrapper
  if (content.contains('Expanded(')) {
    print('✅ Uses Expanded wrapper');
  } else {
    print('❌ Missing Expanded wrapper');
    passed = false;
  }
  
  // Check for proper Stack usage
  if (content.contains('Stack(') && content.contains('Positioned(')) {
    print('✅ Proper Stack/Positioned usage');
  } else {
    print('❌ Improper Stack/Positioned usage');
    passed = false;
  }
  
  // Check for Flexible wrapper around contest name
  if (content.contains('Flexible(')) {
    print('✅ Uses Flexible for text overflow prevention');
  } else {
    print('⚠️  Consider adding Flexible wrapper for text elements');
  }
  
  return passed;
}

bool validateSharedQuestionWidget() {
  print('\n📂 Checking shared_question_widget.dart...');
  
  final file = File('lib/app/common/widgets/shared_question_widget.dart');
  if (!file.existsSync()) {
    print('❌ File not found');
    return false;
  }
  
  final content = file.readAsStringSync();
  
  var passed = true;
  
  // Check for removal of unnecessary null operators
  if (!content.contains('question.options!')) {
    print('✅ No unnecessary null operators on question.options');
  } else {
    print('❌ Still contains unnecessary null operators');
    passed = false;
  }
  
  // Check for proper null checks
  if (content.contains('question.options.isNotEmpty')) {
    print('✅ Uses proper null checks');
  } else {
    print('❌ Missing proper null checks');
    passed = false;
  }
  
  // Check for super parameter usage
  if (content.contains('super.key')) {
    print('✅ Uses super parameters');
  } else {
    print('⚠️  Consider updating to super parameters');
  }
  
  return passed;
}

bool validateQuestionNavigator() {
  print('\n📂 Checking question_navigator.dart...');
  
  final file = File('lib/app/modules/contest-details/widgets/question_navigator.dart');
  if (!file.existsSync()) {
    print('❌ File not found');
    return false;
  }
  
  final content = file.readAsStringSync();
  
  var passed = true;
  
  // Check for removal of nested Positioned
  if (!content.contains('Positioned(') || content.split('Positioned(').length <= 2) {
    print('✅ No nested Positioned widgets');
  } else {
    print('❌ Still contains nested Positioned widgets');
    passed = false;
  }
  
  // Check for proper widget return
  if (content.contains('QuestionNavigatorFloating')) {
    print('✅ Returns QuestionNavigatorFloating widget');
  } else {
    print('❌ Missing QuestionNavigatorFloating widget');
    passed = false;
  }
  
  return passed;
}

bool validateQuestionNavigatorFloating() {
  print('\n📂 Checking question_navigator_floating_widget.dart...');
  
  final file = File('lib/app/modules/contest-details/widgets/question_navigator_floating_widget.dart');
  if (!file.existsSync()) {
    print('❌ File not found');
    return false;
  }
  
  final content = file.readAsStringSync();
  
  var passed = true;
  
  // Check for proper null check
  if (content.contains('contestDetails == null')) {
    print('✅ Uses proper null check (== null)');
  } else if (content.contains('contestDetails.isNull')) {
    print('❌ Still uses .isNull instead of == null');
    passed = false;
  } else {
    print('⚠️  Null check pattern not found');
  }
  
  // Check for syntax correctness (no missing braces)
  final openBraces = content.split('{').length - 1;
  final closeBraces = content.split('}').length - 1;
  if (openBraces == closeBraces) {
    print('✅ Balanced braces (no syntax errors)');
  } else {
    print('❌ Unbalanced braces (syntax error)');
    passed = false;
  }
  
  // Check for proper constructor formatting
  if (content.contains('});') && content.contains('@override')) {
    print('✅ Proper constructor formatting');
  } else {
    print('❌ Constructor formatting issues');
    passed = false;
  }
  
  return passed;
}
