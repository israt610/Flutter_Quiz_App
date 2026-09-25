import 'package:html_unescape/html_unescape.dart';

class HtmlDecoder {
  static final HtmlUnescape _unescape = HtmlUnescape();

  static String decode(String text) {
    if (text.isEmpty) return text;
    
    // First pass using html_unescape
    String decoded = _unescape.convert(text);

    // Extra manual fallback replacements for any residual numeric/named entities
    decoded = decoded
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

    return decoded;
  }
}
