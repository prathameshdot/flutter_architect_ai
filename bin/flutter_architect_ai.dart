import 'dart:io';
import 'package:flutter_architect_ai/cli/cli_interface.dart';
import 'package:flutter_architect_ai/cli/console_output.dart';
import 'package:flutter_architect_ai/services/groq_ai_service.dart';
import 'package:flutter_architect_ai/services/file_generator.dart';
import 'package:flutter_architect_ai/services/boilerplate_generator.dart';
import 'package:flutter_architect_ai/config/environment_config.dart';

void main(List<String> arguments) async {
  try {
    // Initialize environment configuration
    try {
      await EnvironmentConfig.initialize();
    } catch (e) {
      ConsoleOutput.error('Configuration Error: $e');
      exit(1);
    }

    // Parse CLI arguments
    final options = CLIInterface.parseArguments(arguments);
    if (options == null) {
      exit(0);
    }

    // Main execution
    CLIInterface.showWelcome();
    await _generateProject(options);
  } catch (e, stackTrace) {
    ConsoleOutput.error('Fatal Error: $e');
    if (Platform.environment['DEBUG'] == 'true') {
      print(stackTrace);
    }
    exit(1);
  }
}

Future<void> _generateProject(CLIOptions options) async {
  try {
    // Step 1: Validate configuration
    ConsoleOutput.step(1, 'Validating Configuration');
    CLIInterface.showConfig(options);

    // Step 2: Determine project path - use outputDir directly if it's existing Flutter project
    final projectPath = options.outputDir.replaceAll('\\', '/');
    final projectDir = Directory(projectPath);

    // Check if outputDir is an existing Flutter project
    final isExistingFlutterProject =
        await projectDir.exists() &&
        await File('$projectPath/pubspec.yaml').exists() &&
        await File('$projectPath/.metadata').exists();

    String projectName =
        options.description
            ?.toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
            .replaceAll(RegExp(r'_+'), '_')
            .replaceAll('_\$', '') ??
        'flutter_app';

    // If not existing Flutter project, create it with flutter create
    if (!isExistingFlutterProject) {
      ConsoleOutput.step(2, 'Creating Flutter Project');

      // Try to run flutter create, but continue if flutter is not in PATH
      try {
        ConsoleOutput.info('Running: flutter create $projectPath');
        final result = await Process.run('flutter', [
          'create',
          projectPath,
        ], runInShell: true);

        if (result.exitCode != 0) {
          // Check if it's a "command not found" error or actual flutter error
          final stderr = result.stderr.toString().toLowerCase();
          if (stderr.contains('not found') ||
              stderr.contains('is not recognized') ||
              stderr.contains('cannot find')) {
            ConsoleOutput.warning('Flutter CLI not found in PATH');
            ConsoleOutput.info(
              'Creating project directory structure manually...',
            );

            // Create basic project structure manually
            await projectDir.create(recursive: true);
            ConsoleOutput.success('Project directory created at: $projectPath');
          } else {
            ConsoleOutput.error('Failed to create Flutter project');
            ConsoleOutput.error(stderr);
            exit(1);
          }
        } else {
          ConsoleOutput.success('Flutter project created');
        }
      } catch (e) {
        // If flutter command is not available, create structure manually
        if (e.toString().contains('not found') ||
            e.toString().contains('No such file')) {
          ConsoleOutput.warning('Flutter CLI not found in PATH');
          ConsoleOutput.info(
            'Creating project directory structure manually...',
          );

          // Create basic project structure manually
          await projectDir.create(recursive: true);
          ConsoleOutput.success('Project directory created at: $projectPath');
        } else {
          ConsoleOutput.error('Failed to create Flutter project: $e');
          exit(1);
        }
      }
    } else {
      ConsoleOutput.step(2, 'Using Existing Flutter Project');
      ConsoleOutput.success('Found existing Flutter project at: $projectPath');
    }

    // Step 3: Extract features from description
    List<String> features;

    if (options.useAI && options.description != null) {
      ConsoleOutput.step(3, 'Analyzing with AI');
      ConsoleOutput.info('Analyzing project description...');

      try {
        final aiService = GroqAIService();
        final result = await aiService.generateArchitecture(
          projectDescription: options.description!,
          stateManagement: options.stateMgmt,
          backendType: options.backend,
          uiFramework: 'material',
        );

        projectName = (result['projectName'] as String?) ?? projectName;
        features = List<String>.from(result['features'] ?? []);

        CLIInterface.showFeatures(features);
      } catch (e) {
        ConsoleOutput.warning('AI analysis skipped: $e');
        features = _extractDefaultFeatures(options.description ?? '');
      }
    } else {
      features = _extractDefaultFeatures(options.description ?? '');
    }

    // Step 4: Delete and regenerate lib, assets, test folders
    ConsoleOutput.step(4, 'Generating Project Structure');

    // Delete existing folders to regenerate from scratch
    ConsoleOutput.info('Clearing existing structure...');
    final libDir = Directory('$projectPath/lib');
    if (await libDir.exists()) {
      try {
        await libDir.delete(recursive: true);
        ConsoleOutput.success('Deleted: lib');
      } catch (e) {
        ConsoleOutput.warning('Could not delete lib: $e');
      }
    }

    final assetsDir = Directory('$projectPath/assets');
    if (await assetsDir.exists()) {
      try {
        await assetsDir.delete(recursive: true);
        ConsoleOutput.success('Deleted: assets');
      } catch (e) {
        ConsoleOutput.warning('Could not delete assets: $e');
      }
    }

    final testDir = Directory('$projectPath/test');
    if (await testDir.exists()) {
      try {
        await testDir.delete(recursive: true);
        ConsoleOutput.success('Deleted: test');
      } catch (e) {
        ConsoleOutput.warning('Could not delete test: $e');
      }
    }

    final generator = FileGenerator(projectPath: projectPath);

    // Generate lib structure (always fresh)
    ConsoleOutput.info('Generating lib folder...');

    // Generate core modules
    ConsoleOutput.info('  - Generating core modules...');
    await generator.generateCoreStructure({});

    // Generate shared modules
    ConsoleOutput.info('  - Generating shared modules...');
    await generator.generateSharedStructure();

    // Generate features
    ConsoleOutput.info('  - Generating features...');
    for (final feature in features) {
      ConsoleOutput.success('  - Generated feature: $feature');
      final boilerplateGen = BoilerplateGenerator(
        featureName: feature,
        stateManagement: options.stateMgmt,
      );

      await generator.generateFeature(
        featureName: feature,
        stateManagement: options.stateMgmt,
        templates: {
          'entity': boilerplateGen.generateEntityBoilerplate(),
          'model': boilerplateGen.generateModelBoilerplate(),
          'remoteDatasource': boilerplateGen
              .generateRemoteDatasourceBoilerplate(),
          'bloc': boilerplateGen.generateBlocBoilerplate(),
          'riverpodProvider': boilerplateGen.generateRiverpodBoilerplate(),
          'page': boilerplateGen.generatePageBoilerplate(),
        },
      );
    }

    // Generate configuration
    ConsoleOutput.info('  - Generating config modules...');
    await generator.generateConfig(options.stateMgmt, options.backend, {});

    // Generate main.dart
    ConsoleOutput.info('  - Generating main.dart...');
    final mainDartContent = _generateMainDart(projectName);
    await File('$projectPath/lib/main.dart').writeAsString(mainDartContent);
    ConsoleOutput.success('  - main.dart created');

    ConsoleOutput.success('lib folder complete');

    // Generate assets folder structure
    ConsoleOutput.info('Generating assets folder...');
    final assetsDirs = [
      '$projectPath/assets',
      '$projectPath/assets/images',
      '$projectPath/assets/icons',
      '$projectPath/assets/fonts',
    ];

    for (final dir in assetsDirs) {
      final d = Directory(dir);
      if (!await d.exists()) {
        await d.create(recursive: true);
        ConsoleOutput.success('Created: ${dir.split('/').last}');
      }
    }

    // Create .gitkeep files to ensure folders are tracked
    for (final dir in assetsDirs.skip(1)) {
      await File('$dir/.gitkeep').create();
    }

    // Generate test folder
    ConsoleOutput.info('Generating test folder...');
    final testDirPath = Directory('$projectPath/test');

    if (!await testDirPath.exists()) {
      await testDirPath.create(recursive: true);
    }

    // Create example test file
    await File(
      '$projectPath/test/widget_test.dart',
    ).writeAsString(_generateExampleTest(projectName));

    ConsoleOutput.success('test folder complete');

    // Generate root configuration files (only if they don't exist)
    ConsoleOutput.info('Generating configuration files...');

    if (!await File('$projectPath/pubspec.yaml').exists()) {
      await File(
        '$projectPath/pubspec.yaml',
      ).writeAsString(_generatePubspec(projectName, options.description ?? ''));
      ConsoleOutput.success('pubspec.yaml created');
    } else {
      ConsoleOutput.info('pubspec.yaml already exists - skipped');
    }

    if (!await File('$projectPath/analysis_options.yaml').exists()) {
      await File(
        '$projectPath/analysis_options.yaml',
      ).writeAsString(_generateAnalysisOptions());
      ConsoleOutput.success('analysis_options.yaml created');
    } else {
      ConsoleOutput.info('analysis_options.yaml already exists - skipped');
    }

    if (!await File('$projectPath/.gitignore').exists()) {
      await File('$projectPath/.gitignore').writeAsString(_generateGitignore());
      ConsoleOutput.success('.gitignore created');
    } else {
      ConsoleOutput.info('.gitignore already exists - skipped');
    }

    if (!await File('$projectPath/README.md').exists()) {
      await File(
        '$projectPath/README.md',
      ).writeAsString(_generateReadme(projectName, features, options));
      ConsoleOutput.success('README.md created');
    } else {
      ConsoleOutput.info('README.md already exists - skipped');
    }

    if (!await File('$projectPath/CHANGELOG.md').exists()) {
      await File(
        '$projectPath/CHANGELOG.md',
      ).writeAsString(_generateChangelog());
      ConsoleOutput.success('CHANGELOG.md created');
    } else {
      ConsoleOutput.info('CHANGELOG.md already exists - skipped');
    }

    // Step 5: Run flutter clean and flutter pub get
    ConsoleOutput.step(5, 'Running Flutter Commands');

    try {
      ConsoleOutput.info('Running: flutter clean');
      var cleanResult = await Process.run('flutter', [
        'clean',
      ], workingDirectory: projectPath);
      if (cleanResult.exitCode == 0) {
        ConsoleOutput.success('flutter clean completed');
      } else {
        ConsoleOutput.warning('flutter clean warning: ${cleanResult.stderr}');
      }

      ConsoleOutput.info('Running: flutter pub get');
      var pubResult = await Process.run('flutter', [
        'pub',
        'get',
      ], workingDirectory: projectPath);
      if (pubResult.exitCode == 0) {
        ConsoleOutput.success('flutter pub get completed');
      } else {
        ConsoleOutput.warning('flutter pub get warning: ${pubResult.stderr}');
      }
    } catch (e) {
      ConsoleOutput.warning('Flutter commands skipped: $e');
      ConsoleOutput.info('You can run these manually:');
      ConsoleOutput.info('  cd $projectPath');
      ConsoleOutput.info('  flutter clean');
      ConsoleOutput.info('  flutter pub get');
    }

    // Step 6: Summary
    ConsoleOutput.step(6, 'Project Setup Complete');

    final allPaths = [
      projectPath,
      '$projectPath/lib',
      '$projectPath/lib/core',
      ...features.map((f) => '$projectPath/lib/features/$f'),
      '$projectPath/lib/config',
      '$projectPath/lib/shared',
      '$projectPath/assets',
      '$projectPath/assets/images',
      '$projectPath/assets/icons',
      '$projectPath/assets/fonts',
      '$projectPath/test',
    ];

    CLIInterface.showProjectStructure(allPaths);
    CLIInterface.showNextSteps(projectName, projectPath);
  } catch (e, stackTrace) {
    ConsoleOutput.error('Generation failed: $e');
    if (Platform.environment['DEBUG'] == 'true') {
      print(stackTrace);
    }
    exit(1);
  }
}

List<String> _extractDefaultFeatures(String description) {
  if (description.isEmpty) {
    return ['home', 'auth', 'profile'];
  }

  final lower = description.toLowerCase();
  final features = <String>[];

  // Feature keyword mapping
  const keywords = {
    'auth': ['auth', 'authentication', 'login', 'signup', 'password'],
    'profile': ['profile', 'user', 'account', 'settings'],
    'products': ['product', 'catalog', 'shop', 'store', 'ecommerce', 'item'],
    'cart': ['cart', 'shopping', 'basket', 'bag'],
    'orders': ['order', 'purchase', 'checkout', 'booking'],
    'payments': ['payment', 'billing', 'transaction', 'price'],
    'chat': ['chat', 'message', 'messaging', 'communication', 'talk'],
    'notifications': ['notification', 'alert', 'push', 'reminder'],
    'search': ['search', 'filter', 'query', 'find'],
    'analytics': ['analytics', 'tracking', 'metrics', 'stats'],
    'ratings': ['rating', 'review', 'score', 'feedback'],
    'gallery': ['gallery', 'photo', 'image', 'picture'],
  };

  for (final entry in keywords.entries) {
    if (entry.value.any((keyword) => lower.contains(keyword))) {
      features.add(entry.key);
    }
  }

  if (features.isEmpty) {
    features.addAll(['home', 'auth', 'profile']);
  }

  return features;
}

String _generateMainDart(String projectName) =>
    '''import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$projectName'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Clean Architecture',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Your Flutter app is ready with best practices!'),
          ],
        ),
      ),
    );
  }
}
''';

String _generateExampleTest(String projectName) =>
    '''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('$projectName smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we have the text.
    expect(find.text('Welcome to Clean Architecture'), findsOneWidget);
    expect(find.text('Your Flutter app is ready with best practices!'), findsOneWidget);
  });
}
''';

String _generatePubspec(String projectName, String description) =>
    '''name: $projectName
description: $description
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  get_it: ^7.6.0
  http: ^1.1.0
  dartz: ^0.10.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
''';

String _generateAnalysisOptions() =>
    '''include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - camel_case_types
    - camel_case_extensions
    - file_names
    - library_names
    - library_prefixes
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_identifiers
    - prefer_adjacent_string_concatenation
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_equal_for_default_values
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_for_elements_to_map_fromIterable
    - prefer_foreach
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_to_conditional_expression
    - prefer_if_on_single_line_is_else
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_is_nullable
    - prefer_iterable_whereType
    - prefer_null_aware_operators
    - prefer_null_coalescing_operators
    - prefer_relative_import_paths
    - prefer_single_quotes
    - provide_deprecation_message
    - recursive_getters
    - sized_box_for_whitespace
    - sized_box_shrink
    - sized_box_expand
    - tighten_type_of_initializing_formals
    - type_annotate_public_apis
    - type_init_formals
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_null_operator_on_extension_on_nullable
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_statements
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - unrelated_type_equality_checks
    - unsafe_html
    - use_build_context_synchronously
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_getters_to_change_properties
    - use_if_null_to_convert_nulls
    - use_is_even_rather_than_modulo
    - use_key_in_widget_constructors
    - use_late_for_private_fields_and_variables
    - use_null_coalescing
    - use_null_coalescing_operator
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_test_throws_matchers
    - use_to_close_over_close
    - use_build_context_synchronously
    - void_checks
''';

String _generateGitignore() => r'''
.DS_Store
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
pubspec.lock
.env
.env.local
.idea/
.vscode/
*.iml
*.lock
*.log
*.swp
*.swo
*~
.gradle
local.properties
.classpath
.project
.svn/
migrate_working_dir/
coverage/
.coverage
.git/
''';

String _generateReadme(
  String projectName,
  List<String> features,
  CLIOptions options,
) =>
    r'''# ''' +
    projectName +
    r'''

A Flutter application built with Clean Architecture principles.

## Overview

This project demonstrates best practices in Flutter development using Clean Architecture, following SOLID principles and modern design patterns.

## Features

''' +
    features.map((f) => '- $f').join('\n') +
    r'''

## Technology Stack

- **Framework**: Flutter 3.0+
- **Architecture**: Clean Architecture
- **State Management**: ''' +
    options.stateMgmt +
    r'''
- **Backend**: ''' +
    options.backend +
    r'''
- **Language**: Dart 3.0+

## Project Structure

``` 
lib/
├── core/                  # Core utilities, constants, theme
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── services/
│   ├── theme/
│   └── utils/
├── features/              # Feature modules (BLoC pattern)
│   ├── home/
│   ├── auth/
│   └── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
├── config/                # Configuration & routing
├── shared/                # Shared models and constants
└── main.dart

assets/
├── images/
├── icons/
└── fonts/

test/                     # Unit and widget tests
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ''' +
    projectName +
    r'''
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (if needed):
```bash
flutter pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Running Tests

```bash
flutter test
```

## Code Structure

### Feature Layers

Each feature is divided into three layers following Clean Architecture:

1. **Presentation Layer**
   - UI components (Pages, Widgets)
   - State management (BLoC/Riverpod)
   - Event handlers

2. **Domain Layer**
   - Business logic
   - Use cases
   - Repository interfaces
   - Entities

3. **Data Layer**
   - Repository implementations
   - Data sources (Remote/Local)
   - Models
   - Mappers

## Best Practices Applied

- Dependency Inversion Principle (DIP)
- Single Responsibility Principle (SRP)
- Open/Closed Principle (OCP)
- Repository Pattern
- Effective Error Handling
- Responsive UI Design

## Contributing

1. Create a feature branch (git checkout -b feature/AmazingFeature)
2. Commit your changes (git commit -m 'Add some AmazingFeature')
3. Push to the branch (git push origin feature/AmazingFeature)
4. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@example.com or open an issue.
''';

String _generateChangelog() => '''# Changelog

## [1.0.0] - 2026-03-10

### Added
- Initial project setup with Clean Architecture
- Feature structure for modular development
- Core utilities and theme configuration
- Error handling and logging services
- Network and API client setup
- Asset management (images, icons, fonts)
- Test structure

### Features Included
- Authentication module
- Profile management
- Core utilities

## Future Releases

Upcoming features and improvements to be added in future versions.
''';
