import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MixedLaTeXText extends StatelessWidget {
  final String input;
  final TextStyle? textStyle;

  const MixedLaTeXText({super.key, required this.input, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = [];
    final regex = RegExp(r'(\$.*?\$)');
    final matches = regex.allMatches(input);

    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: input.substring(lastEnd, match.start),
          style: textStyle,
        ));
      }

      final latex = match.group(0)!.replaceAll(r'$', '');
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          latex.trim(),
          textStyle: textStyle,
        ),
      ));

      lastEnd = match.end;
    }

    if (lastEnd < input.length) {
      spans.add(TextSpan(
        text: input.substring(lastEnd),
        style: textStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
