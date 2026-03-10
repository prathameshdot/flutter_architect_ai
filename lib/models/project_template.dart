class ProjectTemplate {
  static const String cleanArchitectureStructure = '''
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── strings.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── dio_provider.dart
│   │   └── network_info.dart
│   ├── services/
│   │   ├── logger_service.dart
│   │   ├── analytics_service.dart
│   │   ├── notification_service.dart
│   │   └── storage_service.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── extensions/
│   │   │   ├── build_context_extension.dart
│   │   │   ├── string_extension.dart
│   │   │   └── num_extension.dart
│   │   ├── validators/
│   │   │   ├── email_validator.dart
│   │   │   └── password_validator.dart
│   │   ├── formatters/
│   │   │   └── date_formatter.dart
│   │   └── helpers/
│   │       └── navigation_helper.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── app_loader.dart
│
├── features/
│   ├── [feature_name]/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── remote_datasource.dart
│   │   │   │   └── local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── model.dart
│   │   │   └── repositories/
│   │   │       └── repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── repository.dart
│   │   │   └── usecases/
│   │   │       └── usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── bloc.dart
│   │       │   ├── event.dart
│   │       │   └── state.dart
│   │       ├── riverpod/
│   │       │   └── provider.dart
│   │       ├── provider/
│   │       │   └── provider.dart
│   │       ├── pages/
│   │       │   └── page.dart
│   │       ├── widgets/
│   │       │   └── widget.dart
│   │       └── routes/
│   │           └── routes.dart
│
├── shared/
│   ├── models/
│   │   ├── base_response.dart
│   │   └── pagination_model.dart
│   ├── widgets/
│   │   ├── common_widgets.dart
│   │   └── dialogs/
│   └── repositories/
│       └── shared_repository.dart
│
├── config/
│   ├── routes/
│   │   └── app_router.dart
│   ├── di/
│   │   ├── service_locator.dart
│   │   └── providers.dart
│   └── environment/
│       ├── env_config.dart
│       └── flavor_config.dart
│
├── main_dev.dart
├── main_staging.dart
├── main_production.dart
└── main.dart
''';

  static const String pubspecTemplate = '''name: {PROJECT_NAME}
description: {PROJECT_DESCRIPTION}
version: 1.0.0+1
publish_to: 'none'

environment:
  sdk: '>=3.10.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.6
  google_fonts: ^6.2.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1

  # State Management
  flutter_bloc: ^8.1.4
  bloc: ^8.1.4
  riverpod: ^2.5.1
  flutter_riverpod: ^2.5.1
  provider: ^6.2.1

  # Networking
  dio: ^5.5.0+1
  retrofit: ^4.1.1
  pretty_dio_logger: ^1.3.1

  # Storage
  shared_preferences: ^2.2.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  isar: ^3.1.0+1

  # Database
  sqflite: ^2.3.3+1
  path: ^1.9.0

  # Firebase
  firebase_core: ^2.31.0
  firebase_auth: ^4.21.0
  firebase_database: ^10.5.0
  cloud_firestore: ^4.17.1
  firebase_storage: ^11.7.0
  firebase_messaging: ^14.9.0
  firebase_analytics: ^10.9.0
  firebase_crashlytics: ^3.5.0

  # Utilities
  intl: any
  get_it: ^7.6.4
  uuid: ^4.0.0
  logger: ^2.1.0
  go_router: ^14.2.0
  freezed_annotation: ^2.4.1

  # Validation
  form_validator: ^1.0.0

  # Image Picker
  image_picker: ^1.1.2
  permission_handler: ^11.4.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.11
  freezed: ^2.4.1
  retrofit_generator: ^8.1.4
  hive_generator: ^2.0.1
  isar_generator: ^3.1.0+1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
''';

  static const String analysisOptionsTemplate =
      '''include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
    - annotate_overrides
    - avoid_bool_literals_in_conditional_expressions
    - avoid_classes_with_only_static_members
    - avoid_double_and_int_checks
    - avoid_empty_else
    - avoid_field_initializers_in_const_classes
    - avoid_function_literals_in_foreach_calls
    - avoid_init_to_null
    - avoid_null_checks_in_equality_operators
    - avoid_private_typedef_functions
    - avoid_relative_lib_imports
    - avoid_renaming_method_parameters
    - avoid_returning_null
    - avoid_returning_null_for_future
    - avoid_returning_null_for_void
    - avoid_returning_this
    - avoid_setters_without_getters
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_slow_async_io
    - avoid_types_as_parameter_names
    - avoid_types_unrelated_to_declaration
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - cascade_invocations
    - cast_nullable_to_non_nullable
    - close_sinks
    - comment_references
    - conditional_uri_does_not_exist
    - constant_identifier_names
    - curly_braces_in_flow_control_structures
    - dangling_library_doc_comments
    - deprecated_consistency
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - eol_only_unix_line_endings
    - file_names
    - implementation_imports
    - leading_newlines_in_multiline_strings
    - library_names
    - library_prefixes
    - library_private_types_in_public_api
    - lines_longer_than_80_chars
    - no_adjacent_strings_in_list
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_variables
    - null_closures
    - omit_local_variable_types
    - one_member_abstracts
    - only_throw_errors
    - overridden_fields
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - package_protected_types
    - prefer_asserts_in_initializer_lists
    - prefer_asserts_with_message
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
    - prefer_expression_function_bodies
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_for_elements_to_map_fromIterable
    - prefer_foreach
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_to_conditional_expressions
    - prefer_if_on_single_line_is_else
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_is_operator
    - prefer_iterable_whereType
    - prefer_mixin
    - prefer_null_aware_operators
    - prefer_null_coalescing_cascade
    - prefer_null_coalescing_operators
    - prefer_relative_imports
    - prefer_single_quotes
    - provide_deprecation_message
    - recursive_getters
    - sized_box_for_whitespace
    - sized_box_shrink_expand
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_pub_dependencies
    - sort_unnamed_constructors_first
    - tighten_type_of_variable_declarations
    - type_annotate_public_apis
    - type_init_formals
    - type_literal_in_constant_pattern
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_null_aware_assignments
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_null_on_extension_on_nullable_type
    - unnecessary_nullability_in_type_bounds
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_statements
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - use_build_context_synchronously
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_getters_to_read_properties
    - use_if_null_to_convert_nullability
    - use_is_even_rather_than_modulo
    - use_key_in_widget_constructors
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_test_throws_matchers
    - use_to_close_sinks
    - use_tostring_in_debug_when_needing_diag_info
    - void_checks

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
    - 'build/**'
  errors:
    missing_required_param: error
    missing_return: error
    todo: ignore
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
''';

  static const String mainTemplate = '''import 'package:flutter/material.dart';
import 'config/di/service_locator.dart';
import 'config/di/providers.dart';
import 'config/routes/app_router.dart';
import 'config/environment/env_config.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await Environment.initialize(Flavor.development);
  initializeServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
''';

  static const String serviceLocatorTemplate =
      '''import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/logger_service.dart';

final getIt = GetIt.instance;

void initializeServiceLocator() {
  // Services
  getIt.registerSingleton<LoggerService>(LoggerService());
  getIt.registerSingleton<NetworkInfo>(NetworkInfo());
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Repositories would be registered here
  // Usecases would be registered here
}
''';

  static const String envConfigTemplate =
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

  static const String gitignoreTemplate = '''# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.png
generated_plugin_registrant.dart

# Xcode
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vscode/*
**/ios/**/Flutter/Flutter.podspec
**/ios/**/Flutter/Flutter.framework
**/ios/**/Flutter/Flutter.xcframework
**/ios/**/Flutter/flutter_export_environment.sh
**/ios/**/ServiceDefinitions.json
**/ios/**/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist

# Android
**/android/app/debug
**/android/app/profile
**/android/app/release
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java
**/android/key.properties
**/android/.idea/

# IDE
.idea/
.vscode/
*.swp
*.swo
*.swn
*.iml
.DS_Store

# Environment
.env
.env.local
.env.*.local

# Generated files
*.freezed.dart
*.g.dart
*.config.dart

# OS
.DS_Store
Thumbs.db

# Dependencies
pubspec.lock
''';

  static const Map<String, String> stateManagementPackages = {
    'bloc': 'flutter_bloc: ^8.1.4\nbloc: ^8.1.4',
    'riverpod': 'riverpod: ^2.5.1\nflutter_riverpod: ^2.5.1',
    'provider': 'provider: ^6.2.1',
    'getx': 'get: ^4.6.6',
  };

  static const Map<String, String> backendPackages = {
    'firebase': '''firebase_core: ^2.31.0
firebase_auth: ^4.21.0
cloud_firestore: ^4.17.1
firebase_storage: ^11.7.0
firebase_messaging: ^14.9.0''',
    'supabase': '''supabase_flutter: ^1.10.25
supabase: ^1.11.3''',
    'rest_api': '''dio: ^5.5.0+1
retrofit: ^4.1.1
pretty_dio_logger: ^1.3.1''',
    'graphql': '''graphql: ^5.0.1
graphql_flutter: ^5.1.0''',
  };

  static String getRecommendedPackages({
    required String stateManagement,
    required String backend,
    required bool needsAuth,
    required bool needsLocalDb,
  }) {
    List<String> packages = [
      'cupertino_icons: ^1.0.6',
      'google_fonts: ^6.2.0',
      'flutter_svg: ^2.0.9',
      'cached_network_image: ^3.3.1',
      'intl: any',
      'get_it: ^7.6.4',
      'logger: ^2.1.0',
      'go_router: ^14.2.0',
      'form_validator: ^1.0.0',
    ];

    // Add state management
    packages.add(stateManagementPackages[stateManagement] ?? '');

    // Add backend
    packages.add(backendPackages[backend] ?? '');

    // Add auth if needed
    if (needsAuth && backend != 'firebase') {
      packages.add('jwt_decoder: ^0.4.0');
      packages.add('flutter_secure_storage: ^9.2.2');
    }

    // Add local database if needed
    if (needsLocalDb) {
      packages.add('hive: ^2.2.3');
      packages.add('hive_flutter: ^1.1.0');
    }

    return packages.where((p) => p.isNotEmpty).join('\n  ');
  }
}
