import 'dart:io';

/// Manages environment configuration for Flutter Architect AI
///
/// This class handles loading and accessing environment variables from multiple sources
/// with the following priority order:
/// 1. GitHub Actions secrets/environment variables
/// 2. System environment variables (Docker, CI/CD)
/// 3. .env file (local development)
/// 4. Default values
///
/// Example:
/// ```dart
/// // Initialize once at startup
/// await EnvironmentConfig.initialize();
///
/// // Access configuration throughout the app
/// final apiKey = EnvironmentConfig.groqApiKey;
/// final version = EnvironmentConfig.appVersion;
/// ```
class EnvironmentConfig {
  static late String _groqApiKey;
  static late String _appVersion;
  static late String _logLevel;

  static bool _isInitialized = false;

  /// Initialize environment variables from available sources
  ///
  /// Loads environment variables in priority order:
  /// 1. System environment (GitHub Actions, Docker)
  /// 2. .env file in project root
  /// 3. Default fallback values
  ///
  /// Required variables:
  ///   - GROQ_API_KEY: API key for Groq AI service
  ///
  /// Optional variables:
  ///   - APP_VERSION: Application version (default: 1.0.0)
  ///   - LOG_LEVEL: Logging level (default: INFO)
  ///
  /// Throws an exception if GROQ_API_KEY is not found in any source.
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   await EnvironmentConfig.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Try to load from system environment variables (GitHub Actions, Docker, etc.)
      final systemGroqKey = Platform.environment['GROQ_API_KEY'];
      final systemAppVersion = Platform.environment['APP_VERSION'];
      final systemLogLevel = Platform.environment['LOG_LEVEL'];

      if (systemGroqKey != null) {
        // GitHub Actions environment detected
        _groqApiKey = systemGroqKey;
        _appVersion = systemAppVersion ?? '1.0.0';
        _logLevel = systemLogLevel ?? 'INFO';

        _isInitialized = true;
        return;
      }

      // 2. Try to load from .env file (local development)
      final envFile = File('.env');

      if (await envFile.exists()) {
        final lines = await envFile.readAsLines();
        for (final line in lines) {
          if (line.isEmpty || line.startsWith('#')) continue;

          final parts = line.split('=');
          if (parts.length != 2) continue;

          final key = parts[0].trim();
          final value = parts[1].trim();

          switch (key) {
            case 'GROQ_API_KEY':
              _groqApiKey = value;
              break;
            case 'APP_VERSION':
              _appVersion = value;
              break;
            case 'LOG_LEVEL':
              _logLevel = value;
              break;
          }
        }
      } else {
        // 3. Use defaults if neither system env nor .env exists
        _groqApiKey = '';
        _appVersion = '1.0.0';
        _logLevel = 'INFO';
      }

      // Validate required configuration
      if (_groqApiKey.isEmpty) {
        throw Exception(
          'GROQ_API_KEY not found. Please:\n'
          '  - Local: Set GROQ_API_KEY in .env file\n'
          '  - GitHub: Add GROQ_API_KEY to environment secrets\n'
          '  - Docker: Set GROQ_API_KEY environment variable\n'
          'Get your key from https://console.groq.com/keys',
        );
      }

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize environment: $e');
    }
  }

  /// Get the Groq AI API key
  ///
  /// Returns the API key used for authenticating with Groq AI services.
  /// This key is required for AI-powered project generation features.
  ///
  /// Returns: The Groq API key string
  ///
  /// Throws: Exception if [initialize] hasn't been called yet
  ///
  /// Example:
  /// ```dart
  /// final apiKey = EnvironmentConfig.groqApiKey;
  /// ```
  static String get groqApiKey {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _groqApiKey;
  }

  /// Get the application version
  ///
  /// Returns the version string of Flutter Architect AI.
  /// Used in generated project pubspec.yaml files.
  ///
  /// Returns: Version in semver format (e.g., "1.0.0")
  ///
  /// Throws: Exception if [initialize] hasn't been called yet
  ///
  /// Example:
  /// ```dart
  /// final version = EnvironmentConfig.appVersion; // "1.0.0"
  /// ```
  static String get appVersion {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _appVersion;
  }

  /// Get the logging level
  ///
  /// Returns the logging level for the application.
  /// Controls verbosity of log output: DEBUG, INFO, WARNING, ERROR, CRITICAL.
  /// Defaults to INFO if not specified.
  ///
  /// Returns: Log level string (e.g., "INFO", "DEBUG")
  ///
  /// Throws: Exception if [initialize] hasn't been called yet
  ///
  /// Example:
  /// ```dart
  /// final level = EnvironmentConfig.logLevel; // "INFO"
  /// if (level == "DEBUG") {
  ///   // Enable verbose logging
  /// }
  /// ```
  static String get logLevel {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _logLevel;
  }

  /// Check if environment is properly configured
  ///
  /// Returns true if the environment has been initialized and has
  /// all required configuration values (particularly GROQ_API_KEY).
  ///
  /// Returns: true if properly configured, false otherwise
  ///
  /// Example:
  /// ```dart
  /// if (EnvironmentConfig.isConfigured) {
  ///   // Safe to use AI features
  ///   startAiGeneration();
  /// }
  /// ```
  static bool get isConfigured => _isInitialized && _groqApiKey.isNotEmpty;

  /// Get configuration status for debugging
  ///
  /// Returns a string representation of the initialization state.
  /// Useful for logging and troubleshooting configuration issues.
  ///
  /// Returns: "NOT_INITIALIZED" or "INITIALIZED"
  ///
  /// Example:
  /// ```dart
  /// print('Config status: ${EnvironmentConfig.configStatus}');
  /// // Output: "Config status: INITIALIZED"
  /// ```
  static String get configStatus {
    if (!_isInitialized) return 'NOT_INITIALIZED';
    return 'INITIALIZED';
  }
}
