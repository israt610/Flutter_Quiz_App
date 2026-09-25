import 'package:html_unescape/html_unescape.dart';

class HtmlUtils {
  static final HtmlUnescape _unescape = HtmlUnescape();

  /// Decodes HTML entities commonly returned by OpenTDB (e.g., &quot;, &#039;, &amp;)
  static String decode(String text) {
    if (text.isEmpty) return text;
    
    // First pass unescaping using html_unescape package
    String decoded = _unescape.convert(text);

    // Secondary fallback mapping for any rare missed entities
    return decoded
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&deg;', '°')
        .replaceAll('&divide;', '÷')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—')
        .replaceAll('&hellip;', '…')
        .replaceAll('&nbsp;', ' ');
  }
}
