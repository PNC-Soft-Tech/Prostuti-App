import 'dart:async';
import 'dart:io';

/// Test file to verify per-question timer logic (30 seconds per question)
/// This demonstrates how the model test timer should work

void main() {
  print('🧪 Testing Per-Question Timer Logic (Quick Demo)\n');
  
  // Test with 3-second timer for quick demonstration
  testPerQuestionTimerQuick();
}

void testPerQuestionTimerQuick() {
  print('Test: Per-Question Timer (3 seconds each for demo)');
  print('================================================');
  
  const int secondsPerQuestion = 3; // Quick demo with 3 seconds
  int currentQuestion = 1;
  const int totalQuestions = 3; // Test with 3 questions
  
  void startQuestionTimer(int questionNumber) {
    print('📋 Starting Question $questionNumber of $totalQuestions');
    print('⏱️  Timer: $secondsPerQuestion seconds');
    
    int remainingSeconds = secondsPerQuestion;
    
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        print('⏳ Question $questionNumber - Time Left: ${remainingSeconds}s');
        remainingSeconds--;
      } else {
        print('⏰ Time Up for Question $questionNumber!');
        timer.cancel();
        
        // Auto-move to next question
        if (questionNumber < totalQuestions) {
          currentQuestion++;
          print('🔄 Auto-moving to Question $currentQuestion\n');
          
          // Start timer for next question
          Future.delayed(Duration(milliseconds: 500), () {
            startQuestionTimer(currentQuestion);
          });
        } else {
          print('🏁 All questions completed!');
          
          // Show production timer info
          print('\n📊 Production Implementation:');
          print('• Each question gets 30 seconds');
          print('• Timer resets when changing questions');
          print('• Auto-advances to next question when time expires');
          print('• Shows "Time Left: Xs" for current question');
          
          // Exit after showing info
          Future.delayed(Duration(seconds: 1), () {
            exit(0);
          });
        }
      }
    });
  }
  
  // Start the first question
  startQuestionTimer(currentQuestion);
}
