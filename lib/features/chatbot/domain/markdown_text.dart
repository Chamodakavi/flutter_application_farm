final _fence = RegExp(r'```[^\n]*\n?([\s\S]*?)```');
final _inlineCode = RegExp(r'`([^`\n]*)`');
final _image = RegExp(r'!\[([^\]]*)\]\([^)]*\)');
final _link = RegExp(r'\[([^\]]+)\]\([^)]*\)');
final _autoLink = RegExp(r'<(?:https?://|mailto:)[^>\s]+>');
final _htmlTag = RegExp(r'</?[a-zA-Z][^>]*>');
final _rule = RegExp(r'^\s*([-*_])(\s*\1){2,}\s*$');
final _tableDivider = RegExp(r'^\s*\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?\s*$');
final _heading = RegExp(r'^\s{0,3}#{1,6}\s+');
final _headingTail = RegExp(r'\s+#+\s*$');
final _quote = RegExp(r'^\s*(>\s?)+');
final _bullet = RegExp(r'^\s*[-*+]\s+');
final _task = RegExp(r'^\[[ xX]\]\s+');
final _ordered = RegExp(r'^\s*(\d+)[.)]\s+');
final _strong = RegExp(r'(\*\*|__)(?=\S)(.+?)(?<=\S)\1');
final _starEmphasis = RegExp(r'\*(?=\S)([^*\n]+?)(?<=\S)\*');
final _underscoreEmphasis = RegExp(r'(?<![A-Za-z0-9])_(?=\S)([^_\n]+?)(?<=\S)_(?![A-Za-z0-9])');
final _strike = RegExp(r'~~(.+?)~~');
final _spaces = RegExp(r'[ \t]{2,}');
final _blankLines = RegExp(r'\n{3,}');

/// Plain text of a Markdown reply, for text-to-speech (spec §14.4): headings,
/// bullets, emphasis, links, tables and code marks are removed so the voice
/// reads only the words.
String stripMarkdown(String input) {
  var text = input.replaceAll('\r\n', '\n');
  text = text.replaceAllMapped(_fence, (m) => (m[1] ?? '').trimRight());
  text = text.replaceAllMapped(_inlineCode, (m) => m[1] ?? '');
  text = text.replaceAllMapped(_image, (m) => m[1] ?? '');
  text = text.replaceAllMapped(_link, (m) => m[1] ?? '');
  text = text.replaceAll(_autoLink, '');
  text = text.replaceAll(_htmlTag, '');

  final lines = <String>[];
  for (var line in text.split('\n')) {
    if (_rule.hasMatch(line) || _tableDivider.hasMatch(line)) continue;
    line = line.replaceFirst(_quote, '');
    line = line.replaceFirst(_heading, '').replaceFirst(_headingTail, '');
    line = line.replaceFirst(_bullet, '').replaceFirst(_task, '');
    line = line.replaceFirstMapped(_ordered, (m) => '${m[1]}. ');
    final trimmed = line.trim();
    if (trimmed.startsWith('|') && trimmed.endsWith('|') && trimmed.length > 1) {
      // Table row → its cells, read as a short list.
      line = trimmed
          .substring(1, trimmed.length - 1)
          .split('|')
          .map((cell) => cell.trim())
          .where((cell) => cell.isNotEmpty)
          .join(', ');
    }
    lines.add(line.trimRight());
  }
  text = lines.join('\n');

  text = text.replaceAllMapped(_strong, (m) => m[2] ?? '');
  text = text.replaceAllMapped(_starEmphasis, (m) => m[1] ?? '');
  text = text.replaceAllMapped(_underscoreEmphasis, (m) => m[1] ?? '');
  text = text.replaceAllMapped(_strike, (m) => m[1] ?? '');

  return text.replaceAll(_spaces, ' ').replaceAll(_blankLines, '\n\n').trim();
}
