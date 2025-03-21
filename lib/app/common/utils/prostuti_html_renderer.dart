import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:html_unescape/html_unescape.dart';

/// 📌 Utility Class to Render HTML + KaTeX (Math) Easily
class ProstutiHTMLRender {
  /// Function to render HTML and Math expressions
  static Widget render(String htmlContent) {
    final unescape = HtmlUnescape();
    String decodedContent = unescape.convert(htmlContent); // Decode HTML entities

    return HtmlWidget(
      decodedContent,
      customWidgetBuilder: (element) {
        if (element.localName == 'p' || element.localName == 'div') {
          String content = element.innerHtml;

          if (content.contains(r'$$') || content.contains(r'\(')) {
            return _renderMathAndHTML(content);
          }
        }
        return null;
      },
    );
  }

  /// 🛠 Parses content and renders **both Bengali text & KaTeX Math**
  static Widget _renderMathAndHTML(String content) {
    List<Widget> widgets = [];

    // ✅ Matches both Block Math ($$ ... $$) and Inline Math \( ... \)
    RegExp mathRegex = RegExp(
      r'(\$\$(.*?)\$\$)|(\(\\(.*?)\\\))', // Matches block and inline math
      multiLine: true,
      dotAll: true,
    );

    int lastIndex = 0;
    Iterable<RegExpMatch> matches = mathRegex.allMatches(content);

    for (RegExpMatch match in matches) {
      // 🔹 Add normal text before math expressions
      if (match.start > lastIndex) {
        String normalText = content.substring(lastIndex, match.start).trim();
        if (normalText.isNotEmpty) {
          widgets.add(HtmlWidget(normalText)); // Render HTML for normal text
        }
      }

      // 🔹 Extract LaTeX math expressions
      String? blockMath = match.group(2); // $$ ... $$
      String? inlineMath = match.group(4); // \( ... \)

      if (blockMath != null) {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Math.tex(
            blockMath,
            textStyle: TextStyle(fontSize: 20),
          ),
        ));
      } else if (inlineMath != null) {
        widgets.add(Math.tex(
          inlineMath,
          textStyle: TextStyle(fontSize: 18),
        ));
      }

      lastIndex = match.end;
    }

    // 🔹 Add remaining normal text after last match
    if (lastIndex < content.length) {
      String remainingText = content.substring(lastIndex).trim();
      if (remainingText.isNotEmpty) {
        widgets.add(HtmlWidget(remainingText));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
