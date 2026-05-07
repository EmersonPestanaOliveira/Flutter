String normalizeSearchText(
  String value, {
  bool collapseWhitespace = false,
  bool separatorsAsSpaces = false,
}) {
  var normalized = value.trim().toLowerCase();

  normalized = _replaceMojibakeAccents(normalized);
  normalized = _stripLatinAccents(normalized);

  if (separatorsAsSpaces) {
    normalized = normalized.replaceAll(RegExp(r'[-_]'), ' ');
  }

  if (collapseWhitespace) {
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
  }

  return normalized;
}

String _replaceMojibakeAccents(String value) {
  const replacements = {
    '\u00c3\u00a1': 'a',
    '\u00c3\u00a0': 'a',
    '\u00c3\u00a2': 'a',
    '\u00c3\u00a3': 'a',
    '\u00c3\u00a4': 'a',
    '\u00c3\u00a9': 'e',
    '\u00c3\u00a8': 'e',
    '\u00c3\u00aa': 'e',
    '\u00c3\u00ab': 'e',
    '\u00c3\u00ad': 'i',
    '\u00c3\u00ac': 'i',
    '\u00c3\u00ae': 'i',
    '\u00c3\u00af': 'i',
    '\u00c3\u00b3': 'o',
    '\u00c3\u00b2': 'o',
    '\u00c3\u00b4': 'o',
    '\u00c3\u00b5': 'o',
    '\u00c3\u00b6': 'o',
    '\u00c3\u00ba': 'u',
    '\u00c3\u00b9': 'u',
    '\u00c3\u00bb': 'u',
    '\u00c3\u00bc': 'u',
    '\u00c3\u00a7': 'c',
    '\u00c3\u0192\u00c2\u00a1': 'a',
    '\u00c3\u0192\u00c2\u00a0': 'a',
    '\u00c3\u0192\u00c2\u00a2': 'a',
    '\u00c3\u0192\u00c2\u00a3': 'a',
    '\u00c3\u0192\u00c2\u00a9': 'e',
    '\u00c3\u0192\u00c2\u00aa': 'e',
    '\u00c3\u0192\u00c2\u00ad': 'i',
    '\u00c3\u0192\u00c2\u00b3': 'o',
    '\u00c3\u0192\u00c2\u00b5': 'o',
    '\u00c3\u0192\u00c2\u00ba': 'u',
    '\u00c3\u0192\u00c2\u00a7': 'c',
  };

  var normalized = value;
  for (final entry in replacements.entries) {
    normalized = normalized.replaceAll(entry.key, entry.value);
  }
  return normalized;
}

String _stripLatinAccents(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    buffer.write(
      switch (rune) {
        0x00e1 || 0x00e0 || 0x00e2 || 0x00e3 || 0x00e4 => 'a',
        0x00e9 || 0x00e8 || 0x00ea || 0x00eb => 'e',
        0x00ed || 0x00ec || 0x00ee || 0x00ef => 'i',
        0x00f3 || 0x00f2 || 0x00f4 || 0x00f5 || 0x00f6 => 'o',
        0x00fa || 0x00f9 || 0x00fb || 0x00fc => 'u',
        0x00e7 => 'c',
        _ => String.fromCharCode(rune),
      },
    );
  }
  return buffer.toString();
}
