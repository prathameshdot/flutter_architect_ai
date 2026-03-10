import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment_config.dart';

class GroqAIService {
  static const String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  /// Generate Flutter project architecture based on description
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
              'content': 'You are a Flutter architecture expert. Generate only valid JSON '
                  'responses without markdown formatting or code blocks.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
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
        throw Exception('Groq API error: ${response.statusCode} - ${response.body}');
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

  Future<Map<String, dynamic>> generateFeatureBoilerplate({
    required String featureName,
    required String stateManagement,
  }) async {
    final prompt = '''Generate Flutter clean architecture boilerplate for a "$featureName" feature.
    
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
              'content': 'You are a Dart/Flutter code generation expert. Generate complete, '
                  'production-ready code templates. Return only valid JSON.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
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
        throw Exception('Failed to generate boilerplate: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Boilerplate generation error: $e');
    }
  }

  Future<String> generateFile({
    required String fileName,
    required String fileType,
    required String context,
  }) async {
    final prompt = '''Generate a complete, production-ready Dart file for:

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
              'content': 'You are an expert Dart developer. Generate production-ready code.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
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

  String _capitalize(String str) => str[0].toUpperCase() + str.substring(1);
  String _uncapitalize(String str) => str[0].toLowerCase() + str.substring(1);
}
