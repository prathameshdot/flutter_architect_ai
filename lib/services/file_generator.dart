import 'dart:io';
import 'package:path/path.dart' as path;

/// Generates file and directory structure for Flutter projects
///
/// This class handles the creation of complete project directory structures
/// following Clean Architecture principles. It creates all necessary folders,
/// placeholder files, and boilerplate code templates.
///
/// Example:
/// ```dart
/// final generator = FileGenerator(projectPath: './my_app');
/// await generator.generateCoreStructure({});
/// await generator.generateFeatureStructure('auth', {});
/// ```
class FileGenerator {
  /// The root path where the project will be generated
  final String projectPath;

  /// Creates a new [FileGenerator]
  ///
  /// The [projectPath] is where all generated files and directories
  /// will be created.
  FileGenerator({required this.projectPath});

  /// Create directory structure for a list of directories
  ///
  /// Creates all directories recursively and adds .gitkeep files
  /// to preserve empty directories in version control.
  ///
  /// Parameters:
  ///   - [directories]: List of relative directory paths to create
  ///
  /// Example:
  /// ```dart
  /// await generator.createDirectoryStructure([
  ///   'lib/core/constants',
  ///   'lib/features/auth/data',
  /// ]);
  /// ```
  Future<void> createDirectoryStructure(List<String> directories) async {
    for (final dir in directories) {
      final fullPath = path.join(projectPath, dir);
      await Directory(fullPath).create(recursive: true);

      // Create .gitkeep to preserve empty directories
      final gitkeepFile = File(path.join(fullPath, '.gitkeep'));
      if (!await gitkeepFile.exists()) {
        await gitkeepFile.create();
      }
    }
  }

  /// Create a file with the specified content
  ///
  /// Creates the file at the given path relative to [projectPath].
  /// Automatically creates parent directories if they don't exist.
  /// Can optionally overwrite existing files.
  ///
  /// Parameters:
  ///   - [filePath]: Path to the file relative to project root
  ///   - [content]: Content to write to the file
  ///   - [overwrite]: If true, overwrites existing file (default: false)
  ///
  /// Throws an exception if file creation fails.
  ///
  /// Example:
  /// ```dart
  /// await generator.createFile(
  ///   filePath: 'lib/main.dart',
  ///   content: 'void main() { runApp(MyApp()); }',
  /// );
  /// ```
  Future<void> createFile({
    required String filePath,
    required String content,
    bool overwrite = false,
  }) async {
    final fullPath = path.join(projectPath, filePath);
    final file = File(fullPath);

    // Create parent directories if they don't exist
    await file.parent.create(recursive: true);

    // Check if file exists
    if (await file.exists() && !overwrite) {
      print('File already exists: $filePath (skipping)');
      return;
    }

    try {
      await file.writeAsString(content);
      print('Created: $filePath');
    } catch (e) {
      print('Error creating $filePath: $e');
      rethrow;
    }
  }

  /// Generate a complete feature module structure
  ///
  /// Creates all necessary directories and boilerplate files for a feature
  /// following Clean Architecture principles.
  ///
  /// Parameters:
  ///   - [featureName]: Name of the feature (e.g., 'authentication', 'products')
  ///   - [stateManagement]: State management framework (bloc, riverpod, provider, getx)
  ///   - [templates]: Map of template files to generate
  ///
  /// Creates the following structure:
  /// ```
  /// lib/features/{featureName}/
  ///   data/
  ///     datasources/
  ///     models/
  ///     repositories/
  ///   domain/
  ///     entities/
  ///     repositories/
  ///     usecases/
  ///   presentation/
  ///     bloc/riverpod/provider/getx/
  ///     pages/
  ///     widgets/
  /// ```
  Future<void> generateFeature({
    required String featureName,
    required String stateManagement,
    required Map<String, String> templates,
  }) async {
    final featurePath = 'lib/features/$featureName';

    // Create directory structure
    final structure = [
      '$featurePath/data/datasources',
      '$featurePath/data/models',
      '$featurePath/data/repositories',
      '$featurePath/domain/entities',
      '$featurePath/domain/repositories',
      '$featurePath/domain/usecases',
      '$featurePath/presentation/bloc',
      '$featurePath/presentation/riverpod',
      '$featurePath/presentation/pages',
      '$featurePath/presentation/widgets',
    ];

    await createDirectoryStructure(structure);

    // Create data layer files
    final datasourceName =
        '${_toCamelCase(featureName)}_remote_datasource.dart';
    await createFile(
      filePath: '$featurePath/data/datasources/$datasourceName',
      content: templates['remoteDatasource'] ?? '',
    );

    // Create domain layer files
    final entityName = '${_toCamelCase(featureName)}_entity.dart';
    await createFile(
      filePath: '$featurePath/domain/entities/$entityName',
      content: templates['entity'] ?? '',
    );

    // Create presentation layer based on state management
    if (stateManagement == 'bloc') {
      final blocName = '${_toCamelCase(featureName)}_bloc.dart';
      await createFile(
        filePath: '$featurePath/presentation/bloc/$blocName',
        content: templates['bloc'] ?? '',
      );
    } else if (stateManagement == 'riverpod') {
      final providerName = '${_toCamelCase(featureName)}_provider.dart';
      await createFile(
        filePath: '$featurePath/presentation/riverpod/$providerName',
        content: templates['riverpodProvider'] ?? '',
      );
    }

    // Create page
    final pageName = '${_toCamelCase(featureName)}_page.dart';
    await createFile(
      filePath: '$featurePath/presentation/pages/$pageName',
      content: templates['page'] ?? '',
    );
  }

  /// Generate core directory structure
  ///
  /// Creates all core module directories and generates essential boilerplate files
  /// for common functionality needed across the application including constants,
  /// error handling, networking, theme management, utilities, and services.
  ///
  /// Parameters:
  ///   - [coreTemplates]: Map of custom templates to override defaults
  ///
  /// Creates the following core structure:
  /// ```
  /// lib/core/
  ///   constants/        - Application-wide constants
  ///   error/            - Custom exceptions and failures
  ///   network/          - API client and networking
  ///   services/         - Logging, analytics, device info
  ///   theme/            - Colors, typography, UI theme
  ///   utils/            - Extensions, validators, formatters, helpers
  ///   widgets/          - Reusable UI components
  /// ```
  Future<void> generateCoreStructure(Map<String, String> coreTemplates) async {
    final coreStructure = [
      'lib/core/constants',
      'lib/core/error',
      'lib/core/network',
      'lib/core/services',
      'lib/core/theme',
      'lib/core/utils/extensions',
      'lib/core/utils/validators',
      'lib/core/utils/formatters',
      'lib/core/utils/helpers',
      'lib/core/widgets',
    ];

    await createDirectoryStructure(coreStructure);

    // Create core files
    await createFile(
      filePath: 'lib/core/constants/app_constants.dart',
      content: _generateAppConstants(),
    );

    await createFile(
      filePath: 'lib/core/error/exceptions.dart',
      content: _generateExceptions(),
    );

    await createFile(
      filePath: 'lib/core/error/failures.dart',
      content: _generateFailures(),
    );

    await createFile(
      filePath: 'lib/core/network/api_client.dart',
      content: coreTemplates['apiClient'] ?? _generateApiClient(),
    );

    await createFile(
      filePath: 'lib/core/theme/app_colors.dart',
      content: _generateAppColors(),
    );

    await createFile(
      filePath: 'lib/core/theme/app_theme.dart',
      content: _generateAppTheme(),
    );

    await createFile(
      filePath: 'lib/core/utils/extensions/build_context_extension.dart',
      content: _generateBuildContextExtension(),
    );

    await createFile(
      filePath: 'lib/core/services/logger_service.dart',
      content: _generateLoggerService(),
    );
  }

  /// Generate config directory
  ///
  /// Creates configuration-related directories and files for dependency injection,
  /// environment management, and application routing.
  ///
  /// Parameters:
  ///   - [stateManagement]: State management framework being used
  ///   - [backend]: Backend/API type for the application
  ///   - [templates]: Map of custom configuration templates
  ///
  /// Creates the following structure:
  /// ```
  /// lib/config/
  ///   di/           - Dependency injection and service locator setup
  ///   environment/  - Environment-specific configuration
  ///   routes/       - Application routing configuration
  /// ```
  Future<void> generateConfig(
    String stateManagement,
    String backend,
    Map<String, String> templates,
  ) async {
    final configStructure = [
      'lib/config/di',
      'lib/config/environment',
      'lib/config/routes',
    ];

    await createDirectoryStructure(configStructure);

    await createFile(
      filePath: 'lib/config/di/service_locator.dart',
      content: templates['serviceLocator'] ?? _generateServiceLocator(),
    );

    await createFile(
      filePath: 'lib/config/environment/env_config.dart',
      content: templates['envConfig'] ?? _generateEnvConfig(),
    );

    await createFile(
      filePath: 'lib/config/routes/app_router.dart',
      content: templates['appRouter'] ?? _generateAppRouter(),
    );
  }

  /// Generate project configuration files
  ///
  /// Creates essential project configuration files at the root level including
  /// pubspec.yaml for dependencies, analysis_options.yaml for linting, .gitignore,
  /// and main.dart entry point.
  ///
  /// Parameters:
  ///   - [projectName]: Name of the Flutter project
  ///   - [projectDescription]: Brief description of the project
  ///   - [pubspecContent]: Complete pubspec.yaml content with all dependencies
  ///   - [analysisOptions]: Dart analysis configuration and lint rules
  ///   - [gitignore]: Git ignore patterns for the project
  ///   - [mainDart]: Main application entry point code
  ///
  /// Files created:
  ///   - pubspec.yaml: Dependency and project configuration
  ///   - analysis_options.yaml: Dart analyzer rules
  ///   - .gitignore: Version control ignore patterns
  ///   - lib/main.dart: Application entry point
  ///
  /// Example:
  /// ```dart
  /// await generator.generateConfigFiles(
  ///   projectName: 'my_app',
  ///   projectDescription: 'A beautiful Flutter app',
  ///   pubspecContent: pubspecYamlContent,
  ///   analysisOptions: analysisYamlContent,
  ///   gitignore: gitignoreContent,
  ///   mainDart: mainDartContent,
  /// );
  /// ```
  Future<void> generateConfigFiles({
    required String projectName,
    required String projectDescription,
    required String pubspecContent,
    required String analysisOptions,
    required String gitignore,
    required String mainDart,
  }) async {
    await createFile(
      filePath: 'pubspec.yaml',
      content: pubspecContent,
      overwrite: true,
    );

    await createFile(
      filePath: 'analysis_options.yaml',
      content: analysisOptions,
      overwrite: true,
    );

    await createFile(
      filePath: '.gitignore',
      content: gitignore,
      overwrite: true,
    );

    await createFile(
      filePath: 'lib/main.dart',
      content: mainDart,
      overwrite: true,
    );

    // Create README
    await createFile(
      filePath: 'README.md',
      content: _generateReadme(projectName, projectDescription),
      overwrite: true,
    );

    // Create CHANGELOG
    await createFile(
      filePath: 'CHANGELOG.md',
      content: _generateChangelog(),
      overwrite: true,
    );
  }

  /// Generate shared directory
  Future<void> generateSharedStructure() async {
    final sharedStructure = [
      'lib/shared/models',
      'lib/shared/widgets',
      'lib/shared/repositories',
    ];

    await createDirectoryStructure(sharedStructure);

    await createFile(
      filePath: 'lib/shared/models/base_response.dart',
      content: _generateBaseResponse(),
    );

    await createFile(
      filePath: 'lib/shared/models/pagination_model.dart',
      content: _generatePaginationModel(),
    );
  }

  // Private helper generators

  String _generateAppConstants() => '''/// Application Constants
class AppConstants {
  AppConstants._();

  // API
  static const String apiBaseUrl = 'https://api.example.com';
  static const String apiTimeout = '30000'; // 30 seconds

  // Cache
  static const String userCacheKey = 'user_cache';
  static const String tokenCacheKey = 'auth_token';

  // Pagination
  static const int pageSize = 20;

  // Durations
  static const Duration debounceTime = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);
}
''';

  String _generateExceptions() => '''/// Custom Exceptions
abstract class AppException implements Exception {
  final String message;
  AppException({required this.message});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({required String message}) : super(message: message);
}

class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}

class CacheException extends AppException {
  CacheException({required String message}) : super(message: message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException({required String message}) : super(message: message);
}

class ValidationException extends AppException {
  ValidationException({required String message}) : super(message: message);
}

class NotFoundException extends AppException {
  NotFoundException({required String message}) : super(message: message);
}
''';

  String _generateFailures() => '''/// Failure Result Class
abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  ValidationFailure({required String message}) : super(message: message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({required String message}) : super(message: message);
}

class UnknownFailure extends Failure {
  UnknownFailure({required String message}) : super(message: message);
}
''';

  String _generateApiClient() => '''import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! < 500,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
''';

  String _generateAppColors() => '''import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary
  static const Color secondary = Color(0xFFFF5722);
  static const Color secondaryLight = Color(0xFFFFCCBC);
  static const Color secondaryDark = Color(0xFFE64A19);

  // Background
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);
}
''';

  String _generateAppTheme() => '''import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: const Color(0xFF1E1E1E),
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: AppColors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
''';

  String _generateBuildContextExtension() =>
      '''import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Device padding
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;
  double get topPadding => devicePadding.top;
  double get bottomPadding => devicePadding.bottom;

  /// Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// Check orientation
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration),
    );
  }

  /// Navigate
  void pushNamed(String routeName) => Navigator.of(this).pushNamed(routeName);
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}
''';

  String _generateLoggerService() => '''class LoggerService {
  static const String _debugPrefix = '[DEBUG]';
  static const String _infoPrefix = '[INFO]';
  static const String _warningPrefix = '[WARNING]';
  static const String _errorPrefix = '[ERROR]';

  void debug(String message, {dynamic error, StackTrace? stackTrace}) =>
      _log(_debugPrefix, message, error, stackTrace);

  void info(String message, {dynamic error, StackTrace? stackTrace}) =>
      _log(_infoPrefix, message, error, stackTrace);

  void warning(String message, {dynamic error, StackTrace? stackTrace}) =>
      _log(_warningPrefix, message, error, stackTrace);

  void error(String message, {dynamic err, StackTrace? stackTrace}) =>
      _log(_errorPrefix, message, err, stackTrace);

  void _log(String prefix, String message, dynamic error, StackTrace? stackTrace) {
    print("\$prefix \$message");
    if (error != null) print("\$prefix Error: \$error");
    if (stackTrace != null) print("\$prefix StackTrace: \$stackTrace");
  }
}
''';

  String _generateServiceLocator() => '''import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initializeServiceLocator() {
  // TODO: Register all services, repositories, and use cases here
  
  // Example:
  // getIt.registerSingleton<LoggerService>(LoggerService());
  // getIt.registerSingleton<ApiClient>(ApiClient());
}
''';

  String _generateEnvConfig() =>
      '''enum Flavor { development, staging, production }

class Environment {
  static late Flavor _flavor;
  static late String _baseUrl;
  static late bool _enableLogging;

  static Future<void> initialize(Flavor flavor) async {
    _flavor = flavor;

    switch (flavor) {
      case Flavor.development:
        _baseUrl = 'https://dev-api.example.com';
        _enableLogging = true;
        break;
      case Flavor.staging:
        _baseUrl = 'https://staging-api.example.com';
        _enableLogging = true;
        break;
      case Flavor.production:
        _baseUrl = 'https://api.example.com';
        _enableLogging = false;
        break;
    }
  }

  static Flavor get flavor => _flavor;
  static String get baseUrl => _baseUrl;
  static bool get enableLogging => _enableLogging;
}
''';

  String _generateAppRouter() => '''import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      // TODO: Add your routes here
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    );
  }
}
''';

  String _generateBaseResponse() => '''class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic error;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
        'error': error,
      };
}
''';

  String _generatePaginationModel() => '''class PaginationModel<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalItems;

  PaginationModel({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final List<T> items = [];
    if (json['items'] is List && fromJsonT != null) {
      items.addAll((json['items'] as List).map((e) => fromJsonT(e)));
    }

    return PaginationModel(
      items: items,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalItems: json['totalItems'] ?? 0,
    );
  }
}
''';

  String _generateReadme(String projectName, String description) =>
      '''# $projectName

$description

## Getting Started

### Prerequisites
- Flutter SDK: >=3.10.0
- Dart SDK: >=3.10.0

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/$projectName.git
cd $projectName
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
flutter pub run build_runner build
```

### Running the App

Development:
```bash
flutter run -t lib/main.dart
```

Staging:
```bash
flutter run -t lib/main_staging.dart
```

Production:
```bash
flutter run -t lib/main_production.dart
```

## Project Structure

This project follows Clean Architecture principles with the following structure:

- **lib/core/**: Core functionality, utilities, and services
- **lib/features/**: Feature modules following clean architecture
- **lib/config/**: Configuration, DI, and routing
- **lib/shared/**: Shared models, widgets, and repositories

## Architecture

- **Clean Architecture**: Separation of concerns across presentation, domain, and data layers
- **State Management**: BLoC/Riverpod/Provider pattern
- **Dependency Injection**: GetIt for service locator
- **Routing**: GoRouter for navigation

## Testing

```bash
flutter test
```

## Contributing

Contributions are welcome! Please follow the coding standards defined in `analysis_options.yaml`.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
''';

  String _generateChangelog() => '''# Changelog

## [1.0.0] - 2024-01-01

### Added
- Initial release
- Clean Architecture structure
- Basic features setup
''';

  String _toCamelCase(String str) {
    final parts = str.split('_');
    return parts[0] +
        parts.sublist(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }
}
