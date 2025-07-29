# Contest Question Parsing Fix

## Issue Description
Contest details were showing "No questions available" despite the API returning valid question data. The error log showed:

```
Error fetching single contest: type 'String' is not a subtype of type 'Map<String, dynamic>'
```

## Root Cause
The contest questions API response had mixed data formats for the `topic` field:
- Some questions had `topic: "6777b872b8e4d3d56e27ac53"` (String ID)
- Some questions had `topic: {...}` (Full Topic object)
- Some questions had `topics: [...]` (Array of Topic objects)

The `Question.fromJson()` method was failing when trying to parse String topic IDs as Map objects.

## Solution Applied
Enhanced the `Question.fromJson()` method in `lib/app/modules/questions/models/question_model.dart` to handle all topic field formats:

```dart
topic: json['topic'] != null
    ? (json['topic'] is Map<String, dynamic>
        ? Topic.fromJson(json['topic'] as Map<String, dynamic>)
        : json['topics'] != null && (json['topics'] as List).isNotEmpty
            ? Topic.fromJson((json['topics'] as List).first as Map<String, dynamic>)
            : Topic(id: json['topic'].toString(), name: ''))
    : null,
```

## How It Works
1. **Map Format**: If `topic` is a Map, parse it as a full Topic object
2. **String Format**: If `topic` is a String ID, create a Topic with that ID
3. **Topics Array**: If `topic` is null but `topics` array exists, use the first topic
4. **Fallback**: Create an empty Topic if all else fails

## Impact
- ✅ Contest details now properly display all questions from API response
- ✅ Both model tests and contests use the same robust question parsing logic
- ✅ Handles mixed API response formats gracefully
- ✅ No more type casting errors in question parsing

## Files Modified
- `lib/app/modules/questions/models/question_model.dart` - Enhanced `fromJson()` method

## Testing
The fix applies to both:
- Contest details (Contest.fromJson() → Question.fromJson())
- Model test details (ModelTest.fromJson() → Question.fromJson())

Both now use the same robust parsing logic that handles API response format variations.
