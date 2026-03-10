/// Default CLI output formatter without emojis
///
/// Provides static utility methods for formatting console output in a clean,
/// organized manner. All output is formatted with boxes, headers, and visual
/// separators to make CLI output easy to read and navigate.
///
/// Example usage:
/// ```dart
/// ConsoleOutput.header('Project Generation');
/// ConsoleOutput.step(1, 'Validating Configuration');
/// ConsoleOutput.success('Configuration is valid');
/// ConsoleOutput.info('Processing files...');
/// ```
class ConsoleOutput {
  static final String separator = '=' * 70;
  static final String dash = '-' * 70;

  /// Displays a main header section
  ///
  /// Prints a prominent header with border separators for visual emphasis.
  /// Typically used at the start of major sections.
  ///
  /// Parameters:
  ///   - [title]: The header text to display
  static void header(String title) {
    print('\n$separator');
    print(_centerText(title, 70));
    print('$separator\n');
  }

  /// Displays a sub-header section
  ///
  /// Prints a smaller header with dash separators.
  /// Typically used for subsections within a main section.
  ///
  /// Parameters:
  ///   - [title]: The sub-header text to display
  static void subHeader(String title) {
    print('\n$dash');
    print(title);
    print('$dash\n');
  }

  /// Displays a numbered step message
  ///
  /// Formats the message as "[STEP n]" for tracking multi-step processes.
  ///
  /// Parameters:
  ///   - [step]: Step number
  ///   - [message]: Description of the step being performed
  static void step(int step, String message) {
    print('\n[STEP $step] $message');
    print(dash);
  }

  /// Prints a success message formatted as [OK]
  ///
  /// Parameters:
  ///   - [message]: Success message to display
  static void success(String message) {
    print('[OK] $message');
  }

  /// Prints an informational message formatted as [INFO]
  ///
  /// Parameters:
  ///   - [message]: Informational message to display
  static void info(String message) {
    print('[INFO] $message');
  }

  /// Prints a warning message formatted as [WARN]
  ///
  /// Parameters:
  ///   - [message]: Warning message to display
  static void warning(String message) {
    print('[WARN] $message');
  }

  /// Prints an error message formatted as [ERROR]
  ///
  /// Parameters:
  ///   - [message]: Error message to display
  static void error(String message) {
    print('[ERROR] $message');
  }

  static String _centerText(String text, int width) {
    final padding = ((width - text.length) / 2).toInt();
    return '${' ' * padding}$text';
  }

  /// Prints a blank line to the console
  static void newLine() => print('');

  /// Prints a formatted list of items
  ///
  /// Displays a list of items with optional prefix (default: '  - ').
  /// Useful for displaying multiple options or items in a readable format.
  ///
  /// Parameters:
  ///   - [items]: List of strings to display
  ///   - [prefix]: Prefix for each item (default: '  - ')
  ///
  /// Example:
  /// ```dart
  /// ConsoleOutput.list(['Option 1', 'Option 2', 'Option 3']);
  /// ```
  static void list(List<String> items, {String prefix = '  - '}) {
    for (final item in items) {
      print('$prefix$item');
    }
  }

  /// Prints a formatted box with title and items
  ///
  /// Displays a decorative box with a title and list of items inside.
  /// Width is fixed at 70 characters.
  ///
  /// Parameters:
  ///   - [title]: Title to display at top of box
  ///   - [items]: List of items to display in the box
  ///
  /// Example:
  /// ```dart
  /// ConsoleOutput.box('Generated Files', ['main.dart', 'app.dart']);
  /// ```
  static void box(String title, List<String> items) {
    final width = 70;
    print('+${'=' * (width - 2)}+');
    print('| $title${' ' * (width - 4 - title.length)}|');
    print('+${'-' * (width - 2)}+');
    for (final item in items) {
      print('| $item${' ' * (width - 4 - item.length)}|');
    }
    print('+${'=' * (width - 2)}+\n');
  }
}
