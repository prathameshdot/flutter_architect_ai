import 'dart:io';

class EnvironmentConfig {
  static late String _groqApiKey;
  static late String _appVersion;
  static late String _logLevel;

  static bool _isInitialized = false;

  /// Initialize environment variables from .env file
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
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
        // Try to load from system environment variables
        _groqApiKey = Platform.environment['GROQ_API_KEY'] ?? '';
        _appVersion = Platform.environment['APP_VERSION'] ?? '1.0.0';
        _logLevel = Platform.environment['LOG_LEVEL'] ?? 'INFO';
      }

      // Validate required configuration
      if (_groqApiKey.isEmpty) {
        throw Exception(
          'GROQ_API_KEY not found. Please set it in .env file or GROQ_API_KEY environment variable.',
        );
      }

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize environment: $e');
    }
  }

  static String get groqApiKey {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _groqApiKey;
  }

  static String get appVersion {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _appVersion;
  }

  static String get logLevel {
    if (!_isInitialized) {
      throw Exception('Environment not initialized. Call initialize() first.');
    }
    return _logLevel;
  }

  /// Check if environment is properly configured
  static bool get isConfigured => _isInitialized && _groqApiKey.isNotEmpty;

  /// Get configuration status for debugging
  static String get configStatus {
    if (!_isInitialized) return 'NOT_INITIALIZED';
    return 'INITIALIZED';
  }
}
