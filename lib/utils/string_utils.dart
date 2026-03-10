// String Transformation Utilities
String toPascalCase(String str) {
  return str.split(RegExp('_|-| ')).map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join();
}

String toCamelCase(String str) {
  final pascal = toPascalCase(str);
  if (pascal.isEmpty) return '';
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String toSnakeCase(String str) {
  return str
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      .replaceFirst(RegExp('^_'), '')
      .toLowerCase();
}

String toKebabCase(String str) {
  return toSnakeCase(str).replaceAll('_', '-');
}

String sanitizeProjectName(String name) {
  // Convert to snake case and remove invalid characters
  final sanitized = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceFirst(RegExp('^_'), '')
      .replaceFirst(RegExp('_\$'), '');

  // Ensure it starts with a letter
  if (sanitized.isEmpty || sanitized[0].contains(RegExp(r'[0-9]'))) {
    return 'project_${sanitized.isEmpty ? 'app' : sanitized}';
  }

  return sanitized;
}

// Validation Utilities
bool isValidProjectName(String name) {
  if (name.isEmpty) return false;
  if (name.length > 64) return false;
  if (!RegExp(r'^[a-z][a-z0-9_]*\$').hasMatch(name)) return false;
  return true;
}

bool isValidFeatureName(String name) {
  if (name.isEmpty) return false;
  if (name.length > 50) return false;
  if (!RegExp(r'^[a-z][a-z0-9_]*\$').hasMatch(name)) return false;
  return true;
}

// File path utilities
String joinPath(String a, String b) {
  if (a.isEmpty) return b;
  if (b.isEmpty) return a;
  return '$a/$b';
}

String normalizePath(String path) {
  return path.replaceAll(RegExp(r'\\'), '/');
}

// JSON utilities
bool isValidJson(String str) {
  try {
    // This is a simple check - in production use json.decode
    return (str.startsWith('{') && str.endsWith('}')) ||
        (str.startsWith('[') && str.endsWith(']'));
  } catch (_) {
    return false;
  }
}

// Console utilities
String centerText(String text, int width) {
  final padding = ((width - text.length) / 2).toInt();
  return '${' ' * padding}$text';
}

String createBox(String title, List<String> items, {int width = 70}) {
  final top = '┌${'─' * (width - 2)}┐';
  final titleLine = '│ $title${' ' * (width - 4 - title.length)}│';
  final divider = '├${'─' * (width - 2)}┤';
  final lines = <String>[];

  for (final item in items) {
    if (item.length > width - 4) {
      // Wrap long text
      final wrapped = item
          .split('\n')
          .map((line) => '│ $line${' ' * (width - 4 - line.length)}│')
          .join('\n');
      lines.add(wrapped);
    } else {
      lines.add('│ $item${' ' * (width - 4 - item.length)}│');
    }
  }

  final bottom = '└${'─' * (width - 2)}┘';

  return [top, titleLine, divider, ...lines, bottom].join('\n');
}

// Color codes for terminal output
String colorGreen(String text) => '\x1B[32m$text\x1B[0m';
String colorRed(String text) => '\x1B[31m$text\x1B[0m';
String colorYellow(String text) => '\x1B[33m$text\x1B[0m';
String colorBlue(String text) => '\x1B[34m$text\x1B[0m';
String colorCyan(String text) => '\x1B[36m$text\x1B[0m';
String colorMagenta(String text) => '\x1B[35m$text\x1B[0m';
String colorWhite(String text) => '\x1B[37m$text\x1B[0m';

String bold(String text) => '\x1B[1m$text\x1B[0m';
String dim(String text) => '\x1B[2m$text\x1B[0m';
String italic(String text) => '\x1B[3m$text\x1B[0m';
String underline(String text) => '\x1B[4m$text\x1B[0m';
