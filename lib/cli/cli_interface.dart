import 'console_output.dart';

/// Simplified CLI interface for Flutter Architect AI
class CLIOptions {
  final String?description;
  final String stateMgmt;
  final String backend;
  final String outputDir;
  final bool withAuth;
  final bool withDb;
  final bool useAI;

  CLIOptions({
    this.description,
    this.stateMgmt = 'bloc',
    this.backend = 'rest_api',
    this.outputDir = '.',
    this.withAuth = true,
    this.withDb = true,
    this.useAI = true,
  });
}

class CLIInterface {
  static void showWelcome() {
    ConsoleOutput.header('Flutter Architect AI - Project Generator');
    ConsoleOutput.info('AI-powered Flutter clean architecture generator');
  }

  static void showHelp() {
    ConsoleOutput.header('Flutter Architect AI - Help');
    print('''
USAGE:
  flutter_architect_ai [options]

OPTIONS:
  -n, --name <name>              Project name (optional)
  -s, --state <mgmt>             State management: bloc (default), riverpod, provider
  -b, --backend <type>           Backend: rest_api (default), firebase, supabase
  -o, --output <path>            Output directory (default: current)
  --no-auth                       Skip auth module generation
  --no-db                         Skip database setup
  --no-ai                         Skip AI architecture generation
  -h, --help                      Show this help message
  -v, --version                   Show version

EXAMPLES:

  Generate ecommerce app with AI:
    flutter_architect_ai "Ecommerce app with products, cart, orders"

  Generate with custom options:
    flutter_architect_ai \\
      -n my_app \\
      -s riverpod \\
      -b firebase \\
      -o ~/projects

  Simple project without AI:
    flutter_architect_ai -n todo_app --no-ai

ENVIRONMENT:
  Set GROQ_API_KEY in .env file or system environment variables.
  Copy .env.example to .env and add your Groq API key.
''');
  }

  static void showVersion() {
    print('Flutter Architect AI v1.0.0');
  }

  static void showConfig(CLIOptions options) {
    ConsoleOutput.subHeader('Project Configuration');
    print('State Management:   ${options.stateMgmt}');
    print('Backend:            ${options.backend}');
    print('Output Directory:   ${options.outputDir}');
    print('With Auth Module:   ${options.withAuth ? 'Yes' : 'No'}');
    print('With Database:      ${options.withDb ? 'Yes' : 'No'}');
    print('Use AI Generation:  ${options.useAI ? 'Yes' : 'No'}');
  }

  static void showFeatures(List<String> features) {
    ConsoleOutput.subHeader('Generated Features');
    ConsoleOutput.list(features);
  }

  static CLIOptions? parseArguments(List<String> args) {
    if (args.isEmpty) {
      showWelcome();
      showHelp();
      return null;
    }

    if (args.contains('-h') || args.contains('--help')) {
      showHelp();
      return null;
    }

    if (args.contains('-v') || args.contains('--version')) {
      showVersion();
      return null;
    }

    String? description;
    String stateMgmt = 'bloc';
    String backend = 'rest_api';
    String outputDir = '.';
    bool withAuth = true;
    bool withDb = true;
    bool useAI = true;

    // Parse flags
    for (int i = 0; i < args.length; i++) {
      final arg = args[i];

      if (arg == '--no-auth') {
        withAuth = false;
      } else if (arg == '--no-db') {
        withDb = false;
      } else if (arg == '--no-ai') {
        useAI = false;
      } else if ((arg == '-n' || arg == '--name') && i + 1 < args.length) {
        i++;
      } else if ((arg == '-s' || arg == '--state') && i + 1 < args.length) {
        stateMgmt = args[++i];
      } else if ((arg == '-b' || arg == '--backend') && i + 1 < args.length) {
        backend = args[++i];
      } else if ((arg == '-o' || arg == '--output') && i + 1 < args.length) {
        outputDir = args[++i];
      } else if (!arg.startsWith('-')) {
        description = arg;
      }
    }

    return CLIOptions(
      description: description,
      stateMgmt: stateMgmt,
      backend: backend,
      outputDir: outputDir,
      withAuth: withAuth,
      withDb: withDb,
      useAI: useAI,
    );
  }

  static void showProcessing(String message) {
    ConsoleOutput.info(message);
  }

  static void showError(String message) {
    ConsoleOutput.error(message);
  }

  static void showSuccess(String message) {
    ConsoleOutput.success(message);
  }

  static void showProjectStructure(List<String> paths) {
    ConsoleOutput.subHeader('Generated Structure');
    for (final path in paths.take(15)) {
      final depth = path.split('/').length - 1;
      final indent = '  ' * depth;
      final name = path.split('/').last;
      print('$indent|- $name');
    }
    if (paths.length > 15) {
      print('  ... and ${paths.length - 15} more items');
    }
  }

  static void showNextSteps(String projectName, String outputPath) {
    ConsoleOutput.subHeader('Next Steps');
    print('Project created at: $outputPath\n');
    print('1. Navigate to project:');
    print('   cd $outputPath\n');
    print('2. Install dependencies:');
    print('   flutter pub get\n');
    print('3. Generate code (if needed):');
    print('   flutter pub run build_runner build\n');
    print('4. Run the app:');
    print('   flutter run\n');
    print('5. Run tests:');
    print('   flutter test\n');
    print('Documentation: See README.md');
  }
}
