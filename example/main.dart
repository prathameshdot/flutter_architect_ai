import 'package:flutter_architect_ai/services/file_generator.dart';
import 'package:flutter_architect_ai/config/environment_config.dart';

/// Example usage of Flutter Architect AI
/// 
/// This example demonstrates how to:
/// 1. Initialize the environment configuration
/// 2. Generate project structure with file generator
/// 3. Analyze project description with AI
/// 4. Generate Flutter project architecture
/// 
/// Run with: dart example/main.dart
/// 
/// Make sure to set GROQ_API_KEY in .env or environment variables.
void main() async {
  print('Flutter Architect AI - Example Usage');
  print('=====================================\n');

  try {
    // Step 1: Initialize environment configuration
    print('[1] Initializing environment configuration...');
    await EnvironmentConfig.initialize();
    print('    API Key loaded: ${EnvironmentConfig.groqApiKey.substring(0, 10)}...');
    print('    App Version: ${EnvironmentConfig.appVersion}');
    print('    Log Level: ${EnvironmentConfig.logLevel}\n');

    // Step 2: Define project details
    const projectPath = './example_project';
    const projectName = 'example_app';
    const projectDescription = 'A professional ecommerce app with products, shopping cart, and user authentication';

    print('[2] Project Configuration:');
    print('    Path: $projectPath');
    print('    Name: $projectName');
    print('    Description: $projectDescription\n');

    // Step 3: Generate file structure
    print('[3] Generating project file structure...');
    final generator = FileGenerator(projectPath: projectPath);

    // Generate core modules
    await generator.generateCoreStructure({});
    print('    Core modules generated');

    // Generate shared modules
    await generator.generateSharedStructure();
    print('    Shared modules generated');

    // Generate example feature (auth)
    final features = ['auth', 'products', 'cart'];
    for (final feature in features) {
      await generator.generateFeature(
        featureName: feature,
        stateManagement: 'bloc',
        templates: {},
      );
      print('    Feature module generated: $feature');
    }

    // Generate config modules
    await generator.generateConfig('bloc', 'rest', {});
    print('    Configuration modules generated\n');

    // Step 4: Display configuration options
    print('[4] State Management Options:');
    print('    - bloc (recommended)');
    print('    - riverpod');
    print('    - provider');
    print('    - getx\n');

    print('[5] Backend Integration Support:');
    print('    - REST API');
    print('    - Firebase');
    print('    - Supabase');
    print('    - GraphQL\n');

    // Step 6: Show generated structure
    print('[6] Generated Project Structure:');
    print('    $projectPath/');
    print('      lib/');
    print('        core/');
    print('          constants/');
    print('          error/');
    print('          network/');
    print('          services/');
    print('          theme/');
    print('          utils/');
    print('        features/');
    for (final feature in features) {
      print('          $feature/');
      print('            data/');
      print('            domain/');
      print('            presentation/');
    }
    print('        config/');
    print('        shared/');
    print('        main.dart');
    print('      assets/');
    print('        images/');
    print('        icons/');
    print('        fonts/');
    print('      test/\n');

    print('[7] Next Steps:');
    print('    1. Navigate to project: cd $projectPath');
    print('    2. Get dependencies: flutter pub get');
    print('    3. Run the app: flutter run');
    print('    4. Start developing!\n');

    print('Example completed successfully!');
    print('For more information, visit: https://pub.dev/packages/flutter_architect_ai');
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
