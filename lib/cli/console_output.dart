/// Default CLI output formatter without emojis
class ConsoleOutput {
  static final String separator = '=' * 70;
  static final String dash = '-' * 70;

  static void header(String title) {
    print('\n$separator');
    print(_centerText(title, 70));
    print('$separator\n');
  }

  static void subHeader(String title) {
    print('\n$dash');
    print(title);
    print('$dash\n');
  }

  static void step(int step, String message) {
    print('\n[STEP $step] $message');
    print(dash);
  }

  static void success(String message) {
    print('[OK] $message');
  }

  static void info(String message) {
    print('[INFO] $message');
  }

  static void warning(String message) {
    print('[WARN] $message');
  }

  static void error(String message) {
    print('[ERROR] $message');
  }

  static String _centerText(String text, int width) {
    final padding = ((width - text.length) / 2).toInt();
    return '${' ' * padding}$text';
  }

  static void newLine() => print('');

  static void list(List<String> items, {String prefix = '  - '}) {
    for (final item in items) {
      print('$prefix$item');
    }
  }

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
