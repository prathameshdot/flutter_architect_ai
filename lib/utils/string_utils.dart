// String Transformation Utilities

/// Converts a string to PascalCase format
///
/// Example: 'my_project' -> 'MyProject', 'my-project' -> 'MyProject'
///
/// Returns: The string in PascalCase format
String toPascalCase(String str) {
  return str.split(RegExp('_|-| ')).map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join();
}

/// Converts a string to camelCase format
///
/// Example: 'my_project' -> 'myProject', 'my-project' -> 'myProject'
///
/// Returns: The string in camelCase format
String toCamelCase(String str) {
  final pascal = toPascalCase(str);
  if (pascal.isEmpty) return '';
  return pascal[0].toLowerCase() + pascal.substring(1);
}

/// Converts a string to snake_case format
///
/// Example: 'MyProject' -> 'my_project', 'my-project' -> 'my_project'
///
/// Returns: The string in snake_case format
String toSnakeCase(String str) {
  return str
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      .replaceFirst(RegExp('^_'), '')
      .toLowerCase();
}

/// Converts a string to kebab-case format
///
/// Example: 'MyProject' -> 'my-project', 'my_project' -> 'my-project'
///
/// Returns: The string in kebab-case format
String toKebabCase(String str) {
  return toSnakeCase(str).replaceAll('_', '-');
}

/// Sanitizes a project name for use as a Dart package name
///
/// Converts the name to snake_case, removes invalid characters,
/// and ensures it starts with a letter. This function ensures the
/// result is a valid Dart package identifier.
///
/// Returns: A sanitized project name
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

/// Validates if a string is a valid Dart package name
///
/// A valid project name must:
/// - Start with a lowercase letter
/// - Contain only lowercase letters, numbers, and underscores
/// - Be between 1 and 64 characters
///
/// Returns: true if valid, false otherwise
bool isValidProjectName(String name) {
  if (name.isEmpty) return false;
  if (name.length > 64) return false;
  if (!RegExp(r'^[a-z][a-z0-9_]*\$').hasMatch(name)) return false;
  return true;
}

/// Validates if a string is a valid feature name
///
/// A valid feature name must:
/// - Start with a lowercase letter
/// - Contain only lowercase letters, numbers, and underscores
/// - Be less than 50 characters
///
/// Returns: true if valid, false otherwise
bool isValidFeatureName(String name) {
  if (name.isEmpty) return false;
  if (name.length > 50) return false;
  if (!RegExp(r'^[a-z][a-z0-9_]*\$').hasMatch(name)) return false;
  return true;
}

// File path utilities

/// Joins two path components with forward slash
///
/// Example: joinPath('lib', 'models') -> 'lib/models'
///
/// Parameters:
///   - [a]: First path component
///   - [b]: Second path component
///
/// Returns: Combined path
String joinPath(String a, String b) {
  if (a.isEmpty) return b;
  if (b.isEmpty) return a;
  return '$a/$b';
}

/// Normalizes path separators to forward slashes
///
/// Converts backslashes to forward slashes for cross-platform compatibility.
///
/// Returns: Normalized path
String normalizePath(String path) {
  return path.replaceAll(RegExp(r'\\'), '/');
}

// JSON utilities

/// Validates if a string is valid JSON
///
/// Performs a basic check to see if the string starts and ends
/// with valid JSON delimiters ({} or []).
///
/// Returns: true if appears to be valid JSON, false otherwise
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

/// Centers text within a specified width
///
/// Example: centerText('Hello', 10) -> '  Hello   '
///
/// Parameters:
///   - [text]: Text to center
///   - [width]: Total width to center within
///
/// Returns: Centered text
String centerText(String text, int width) {
  final padding = ((width - text.length) / 2).toInt();
  return '${' ' * padding}$text';
}

/// Creates a formatted box with title and items
///
/// Generates a text-based box with borders, useful for CLI output.
/// Automatically wraps long lines to fit within the specified width.
///
/// Parameters:
///   - [title]: Title to display in the box
///   - [items]: List of items to display
///   - [width]: Width of the box (default 70)
///
/// Returns: Formatted box as a string
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
