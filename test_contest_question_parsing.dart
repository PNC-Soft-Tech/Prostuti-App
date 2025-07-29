import 'dart:developer';
import 'lib/app/modules/questions/models/question_model.dart';

void testContestQuestionParsing() {
  // Test data from the actual API response
  final Map<String, dynamic> question1 = {
    '_id': '6777c283b8e4d3d56e27ad0b',
    'title': 'ব্যাকএন্ড ডেভেলপমেন্টের জন্য সবচেয়ে জনপ্রিয় ফ্রেমওয়ার্ক কোনটি?',
    'options': [
      {'title': 'Express.js', 'order': 1, 'isCorrect': true, '_id': '68524b1f7d50130a5c80cceb'},
      {'title': 'Spring', 'order': 1, 'isCorrect': false, '_id': '68524b1f7d50130a5c80ccec'},
      {'title': 'Django', 'order': 1, 'isCorrect': false, '_id': '68524b1f7d50130a5c80cced'},
      {'title': 'Ruby on Rails', 'order': 1, 'isCorrect': false, '_id': '68524b1f7d50130a5c80ccee'}
    ],
    'explanation': 'ব্যাকএন্ড ডেভেলপমেন্টের জন্য Express.js একটি জনপ্রিয় ফ্রেমওয়ার্ক।',
    'topic': '6777b872b8e4d3d56e27ac53', // String format
    'rightAnswer': 'a',
    'isGrid': true,
    'marks': 1,
    'topics': [] // Empty array
  };

  final Map<String, dynamic> question2 = {
    '_id': '6777bf59b8e4d3d56e27ac72',
    'title': 'Who wrote the play \'Romeo and Juliet\'?',
    'options': [
      {'title': 'Charles Dickens', 'order': 1, 'isCorrect': false, '_id': '67879d0d55440b266f779ea9'},
      {'title': 'William Shakespeare', 'order': 1, 'isCorrect': true, '_id': '67879d0d55440b266f779eaa'},
      {'title': 'Jane Austen', 'order': 1, 'isCorrect': false, '_id': '67879d0d55440b266f779eab'},
      {'title': 'Leo Tolstoy', 'order': 1, 'isCorrect': false, '_id': '67879d0d55440b266f779eac'}
    ],
    'explanation': '<p>\'Romeo and Juliet\' was written by William Shakespeare.</p>',
    'topic': '6777b928b8e4d3d56e27ac5c', // String format
    'rightAnswer': 'b',
    'isGrid': false,
    'marks': 1,
    'topics': [
      {
        '_id': '6777b928b8e4d3d56e27ac5c',
        'name': 'Geometry',
        'slug': 'geometry',
        'subject': {
          '_id': '6777b872b8e4d3d56e27ac50',
          'name': 'গণিত',
          'slug': 'mathematics'
        }
      }
    ] // Array with full objects
  };

  try {
    // Test parsing question 1 (topic as String, empty topics array)
    log('Testing Question 1 parsing...');
    final q1 = Question.fromJson(question1);
    log('Question 1 parsed successfully: ${q1.title}');
    log('Question 1 topic: ${q1.topic?.id} - ${q1.topic?.name}');
    
    // Test parsing question 2 (topic as String, topics array with full objects)
    log('Testing Question 2 parsing...');
    final q2 = Question.fromJson(question2);
    log('Question 2 parsed successfully: ${q2.title}');
    log('Question 2 topic: ${q2.topic?.id} - ${q2.topic?.name}');
    
    log('✅ All question parsing tests passed!');
  } catch (e, stackTrace) {
    log('❌ Question parsing failed: $e');
    log('Stack trace: $stackTrace');
  }
}

void main() {
  testContestQuestionParsing();
}
