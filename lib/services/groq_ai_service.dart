import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment_config.dart';

/// Service for AI-powered Flutter project generation using Groq API
///
/// This service leverages the Groq API to generate Flutter project architectures,
/// feature boilerplates, and individual files. It communicates with the Groq
/// API endpoint using LLMs like mixtral-8x7b-32768 and llama-3.1-70b-versatile.
///
/// All API calls are authenticated using the GROQ_API_KEY from environment configuration.
/// The service formats prompts to ensure JSON responses when needed, with fallback
/// parsing to extract JSON from text-wrapped responses.
///
/// Example usage:
/// ```dart
/// final service = GroqAIService();
/// final architecture = await service.generateArchitecture(
///   projectDescription: "E-commerce mobile app",
///   stateManagement: "Riverpod",
///   backendType: "REST API",
///   uiFramework: "Flutter",
/// );
/// ```
class GroqAIService {
  static const String baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  /// Generate Flutter project architecture based on description
  ///
  /// Analyzes the provided project specifications and generates a comprehensive
  /// Flutter architecture with recommended modules, layers, state management,
  /// backend integration, and third-party packages.
  ///
  /// Parameters:
  ///   - projectDescription: High-level description of the application
  ///   - stateManagement: Chosen state management solution (e.g., "Riverpod", "BLoC")
  ///   - backendType: Backend integration type (e.g., "REST API", "GraphQL")
  ///   - uiFramework: UI framework choice (typically "Flutter")
  ///
  /// Returns: A map containing:
  ///   - projectName: Generated project name
  ///   - features: List of recommended features
  ///   - coreModules: Essential modules for the project
  ///   - architecture: Layer and package structure
  ///   - stateManagement: Confirmed state management approach
  ///   - backendIntegration: Backend configuration
  ///   - apiEndpoints: Suggested API endpoints
  ///   - databaseType: Recommended database (sqlite, firestore)
  ///   - notificationSystem: Recommended notifications service
  ///   - testingStrategy: Recommended test types to implement
  ///
  /// Throws: Exception if API call fails or response is invalid JSON
  ///
  /// Example:
  /// ```dart
  /// final architecture = await service.generateArchitecture(
  ///   projectDescription: "Real-time chat application with UI customization",
  ///   stateManagement: "Riverpod",
  ///   backendType: "Firebase",
  ///   uiFramework: "Flutter",
  /// );
  /// print(architecture['projectName']); // "flutter_chat_app"
  /// ```
  Future<Map<String, dynamic>> generateArchitecture({
    required String projectDescription,
    required String stateManagement,
    required String backendType,
    required String uiFramework,
  }) async {
    final prompt = _buildArchitecturePrompt(
      projectDescription,
      stateManagement,
      backendType,
      uiFramework,
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${EnvironmentConfig.groqApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a Flutter architecture expert. Generate only valid JSON '
                  'responses without markdown formatting or code blocks.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Parse the JSON response
        try {
          return jsonDecode(content);
        } catch (e) {
          // Try to extract JSON if wrapped text
          final jsonStart = content.indexOf('{');
          final jsonEnd = content.lastIndexOf('}');
          if (jsonStart != -1 && jsonEnd != -1) {
            final jsonStr = content.substring(jsonStart, jsonEnd + 1);
            return jsonDecode(jsonStr);
          }
          throw Exception('Invalid JSON response from AI: $content');
        }
      } else {
        throw Exception(
          'Groq API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to generate architecture: $e');
    }
  }

  String _buildArchitecturePrompt(
    String description,
    String stateManagement,
    String backendType,
    String uiFramework,
  ) {
    return '''Generate a complete Flutter Clean Architecture for the following project:

Project Description: $description
State Management: $stateManagement
Backend: $backendType
UI Framework: $uiFramework

Return a JSON object with this exact structure:
{
  "projectName": "generated_name",
  "features": ["feature1", "feature2", "feature3"],
  "coreModules": ["services", "utils", "constants", "theme"],
  "architecture": {
    "layers": {
      "presentation": ["screens", "widgets", "providers"],
      "domain": ["entities", "repositories", "usecases"],
      "data": ["datasources", "repositories", "models"]
    }
  },
  "stateManagement": "$stateManagement",
  "backendIntegration": "$backendType",
  "apiEndpoints": ["endpoint1", "endpoint2"],
  "useExternalPackages": ["package1", "package2"],
  "authenticationMethod": "jwt_or_oauth",
  "databaseType": "sqlite_or_firestore",
  "notificationSystem": "firebase_messaging_or_local",
  "analyticsIntegration": true,
  "loggingStrategy": "firebase_crashlytics_or_logger",
  "testingStrategy": ["unit_tests", "integration_tests"]
}

Only return valid JSON without any markdown, code blocks, or explanations.''';
  }

  /// Generate feature-specific boilerplate code for Flutter clean architecture
  ///
  /// Creates production-ready code templates for a specific feature including
  /// screens, entities, models, repositories, usecases, and state management
  /// components. This accelerates feature development by automatically generating
  /// scaffold code following clean architecture principles.
  ///
  /// Parameters:
  ///   - featureName: Name of the feature (e.g., "login", "profile", "products")
  ///   - stateManagement: State management solution (e.g., "Riverpod", "BLoC", "GetX")
  ///
  /// Returns: A map containing templates for:
  ///   - screenTemplate: StatelessWidget or StatefulWidget implementation
  ///   - entityTemplate: Domain layer entity class
  ///   - modelTemplate: Data layer model with JSON serialization
  ///   - repositoryTemplate: Repository pattern implementation
  ///   - usecaseTemplate: Usecase/interactor class
  ///   - providerTemplate: State management provider/controller
  ///   - stateTemplate: State class for managing feature state
  ///   - datasourceTemplate: Remote data source implementation
  ///
  /// Throws: Exception if API call fails or response cannot be parsed
  ///
  /// Example:
  /// ```dart
  /// final boilerplate = await service.generateFeatureBoilerplate(
  ///   featureName: "authentication",
  ///   stateManagement: "Riverpod",
  /// );
  /// // Use templates to scaffold auth feature structure
  /// ```
  Future<Map<String, dynamic>> generateFeatureBoilerplate({
    required String featureName,
    required String stateManagement,
  }) async {
    final prompt =
        '''Generate Flutter clean architecture boilerplate for a "$featureName" feature.
    
State Management: $stateManagement

Return JSON with this structure:
{
  "screenTemplate": "class ${_capitalize(featureName)}Screen extends StatelessWidget {...}",
  "entityTemplate": "class ${_capitalize(featureName)}Entity {...}",
  "modelTemplate": "class ${_capitalize(featureName)}Model {...}",
  "repositoryTemplate": "class ${_capitalize(featureName)}Repository {...}",
  "usecaseTemplate": "class Get${_capitalize(featureName)}Usecase {...}",
  "providerTemplate": "final ${_uncapitalize(featureName)}Provider = StateNotifierProvider(...)",
  "stateTemplate": "class ${_capitalize(featureName)}State {...}",
  "datasourceTemplate": "class ${_capitalize(featureName)}RemoteDataSource {...}"
}

Only return valid JSON without markdown.''';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${EnvironmentConfig.groqApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a Dart/Flutter code generation expert. Generate complete, '
                  'production-ready code templates. Return only valid JSON.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.5,
          'max_tokens': 3000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        try {
          return jsonDecode(content);
        } catch (e) {
          final jsonStart = content.indexOf('{');
          final jsonEnd = content.lastIndexOf('}');
          if (jsonStart != -1 && jsonEnd != -1) {
            final jsonStr = content.substring(jsonStart, jsonEnd + 1);
            return jsonDecode(jsonStr);
          }
          throw Exception('Invalid JSON response');
        }
      } else {
        throw Exception(
          'Failed to generate boilerplate: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Boilerplate generation error: $e');
    }
  }

  /// Generate complete, production-ready Dart/YAML/JSON file content
  ///
  /// Creates fully functional file content for any Dart file type or configuration
  /// file needed in a Flutter project. The generated content follows Dart style
  /// guidelines, includes proper documentation, error handling, and uses clean
  /// code practices. Files are immediately usable without modification.
  ///
  /// Parameters:
  ///   - fileName: Name of the file to generate (e.g., "api_client.dart", "constants.dart")
  ///   - fileType: File type/extension (dart, yaml, json, etc)
  ///   - context: Contextual information about the file's purpose and role
  ///
  /// Returns: Complete file content as a string, ready to write to disk
  ///
  /// Supported file types:
  ///   - dart: Dart code files
  ///   - yaml: Configuration files (pubspec.yaml, analysis_options.yaml)
  ///   - json: Data and configuration files
  ///   - md: Documentation and README files
  ///
  /// Throws: Exception if API call fails
  ///
  /// Example:
  /// ```dart
  /// final apiClientCode = await service.generateFile(
  ///   fileName: "api_client.dart",
  ///   fileType: "dart",
  ///   context: "HTTP client for REST API integration with error handling and interceptors",
  /// );
  /// File('lib/core/network/api_client.dart').writeAsStringSync(apiClientCode);
  /// ```
  Future<String> generateFile({
    required String fileName,
    required String fileType,
    required String context,
  }) async {
    final prompt =
        '''Generate a complete, production-ready Dart file for:

File Name: $fileName
File Type: $fileType (dart, yaml, json, etc)
Context: $context

Requirements:
- Follow Dart style guide
- Add proper documentation
- Include error handling
- Use clean code practices
- Make it immediately usable

Return only the file content without markdown or code blocks.''';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${EnvironmentConfig.groqApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert Dart developer. Generate production-ready code.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.3,
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to generate file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('File generation error: $e');
    }
  }

  /// Convert the first character of a string to uppercase
  ///
  /// Used for generating proper class names and identifiers
  /// from feature or entity names.
  ///
  /// Example:
  /// ```dart
  /// _capitalize('user'); // Returns 'User'
  /// _capitalize('Profile'); // Returns 'Profile'
  /// ```
  String _capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  /// Convert the first character of a string to lowercase
  ///
  /// Used for generating variable names, provider names, and
  /// function names from entity identifiers.
  ///
  /// Example:
  /// ```dart
  /// _uncapitalize('User'); // Returns 'user'
  /// _uncapitalize('profile'); // Returns 'profile'
  /// ```
  String _uncapitalize(String str) => str[0].toLowerCase() + str.substring(1);
}
