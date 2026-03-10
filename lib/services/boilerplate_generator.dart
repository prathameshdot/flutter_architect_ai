/// Generates boilerplate code for different state management patterns
///
/// This class generates template code for feature modules based on the selected
/// state management framework (BLoC, Riverpod, Provider, or GetX).
///
/// Example:
/// ```dart
/// final generator = BoilerplateGenerator(
///   featureName: 'authentication',
///   stateManagement: 'bloc',
/// );
/// final blocCode = generator.generateBlocBoilerplate();
/// ```
class BoilerplateGenerator {
  /// The name of the feature this generator creates boilerplate for
  final String featureName;

  /// The state management framework to use (bloc, riverpod, provider, getx)
  final String stateManagement;

  /// Creates a new [BoilerplateGenerator]
  ///
  /// Parameters:
  ///   - [featureName]: Name of the feature (e.g., 'auth', 'products')
  ///   - [stateManagement]: State management pattern (e.g., 'bloc', 'riverpod')
  BoilerplateGenerator({
    required this.featureName,
    required this.stateManagement,
  });

  /// Generate bloc pattern boilerplate
  ///
  /// Returns a complete BLoC implementation template with events, states,
  /// and event handlers for the feature.
  ///
  /// The generated code includes:
  /// - Event classes for feature actions
  /// - State classes for feature states
  /// - Bloc class extending `Bloc<Event, State>`
  /// - Event handler methods
  ///
  /// Returns: Complete BLoC boilerplate code as a String
  String generateBlocBoilerplate() =>
      '''
import 'package:bloc/bloc.dart';

part '${_toSnakeCase(featureName)}_event.dart';
part '${_toSnakeCase(featureName)}_state.dart';

class ${_toPascalCase(featureName)}Bloc extends Bloc<${_toPascalCase(featureName)}Event, ${_toPascalCase(featureName)}State> {
  ${_toPascalCase(featureName)}Bloc() : super(${_toPascalCase(featureName)}Initial()) {
    on<${_toPascalCase(featureName)}InitialEvent>(_on${_toPascalCase(featureName)}Initial);
  }

  Future<void> _on${_toPascalCase(featureName)}Initial(
    ${_toPascalCase(featureName)}InitialEvent event,
    Emitter<${_toPascalCase(featureName)}State> emit,
  ) async {
    emit(${_toPascalCase(featureName)}Loading());
    try {
      // TODO: Implement your logic here
      emit(${_toPascalCase(featureName)}Loaded());
    } catch (e) {
      emit(${_toPascalCase(featureName)}Error(message: e.toString()));
    }
  }
}
''';

  String generateBlocEventBoilerplate() =>
      '''
part of '${_toSnakeCase(featureName)}_bloc.dart';

abstract class ${_toPascalCase(featureName)}Event extends Equatable {
  const ${_toPascalCase(featureName)}Event();

  @override
  List<Object?> get props => [];
}

class ${_toPascalCase(featureName)}InitialEvent extends ${_toPascalCase(featureName)}Event {
  const ${_toPascalCase(featureName)}InitialEvent();
}
''';

  String generateBlocStateBoilerplate() =>
      '''
part of '${_toSnakeCase(featureName)}_bloc.dart';

abstract class ${_toPascalCase(featureName)}State extends Equatable {
  const ${_toPascalCase(featureName)}State();

  @override
  List<Object?> get props => [];
}

class ${_toPascalCase(featureName)}Initial extends ${_toPascalCase(featureName)}State {
  const ${_toPascalCase(featureName)}Initial();
}

class ${_toPascalCase(featureName)}Loading extends ${_toPascalCase(featureName)}State {
  const ${_toPascalCase(featureName)}Loading();
}

class ${_toPascalCase(featureName)}Loaded extends ${_toPascalCase(featureName)}State {
  const ${_toPascalCase(featureName)}Loaded();
}

class ${_toPascalCase(featureName)}Error extends ${_toPascalCase(featureName)}State {
  final String message;
  const ${_toPascalCase(featureName)}Error({required this.message});

  @override
  List<Object?> get props => [message];
}
''';

  /// Generate Riverpod pattern boilerplate
  ///
  /// Returns a complete Riverpod implementation with StateNotifier, State class,
  /// and provider setup for the feature.
  ///
  /// The generated code includes:
  /// - StateNotifier extending class
  /// - State enum and state class
  /// - Provider definition
  /// - Loading, loaded, and error states
  ///
  /// Returns: Complete Riverpod boilerplate code as a String
  String generateRiverpodBoilerplate() =>
      '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ${_toCamelCase(featureName)}Provider = StateNotifierProvider<${_toPascalCase(featureName)}Notifier, ${_toPascalCase(featureName)}State>((ref) {
  return ${_toPascalCase(featureName)}Notifier();
});

class ${_toPascalCase(featureName)}Notifier extends StateNotifier<${_toPascalCase(featureName)}State> {
  ${_toPascalCase(featureName)}Notifier() : super(const ${_toPascalCase(featureName)}State.initial());

  Future<void> initialize() async {
    state = const ${_toPascalCase(featureName)}State.loading();
    try {
      // TODO: Implement your logic here
      state = const ${_toPascalCase(featureName)}State.loaded(data: null);
    } catch (e) {
      state = ${_toPascalCase(featureName)}State.error(message: e.toString());
    }
  }
}

enum ${_toPascalCase(featureName)}Status { initial, loading, loaded, error }

class ${_toPascalCase(featureName)}State {
  final ${_toPascalCase(featureName)}Status status;
  final dynamic data;
  final String? errorMessage;

  const ${_toPascalCase(featureName)}State({
    required this.status,
    this.data,
    this.errorMessage,
  });

  const ${_toPascalCase(featureName)}State.initial() : this(status: ${_toPascalCase(featureName)}Status.initial);

  const ${_toPascalCase(featureName)}State.loading() : this(status: ${_toPascalCase(featureName)}Status.loading);

  const ${_toPascalCase(featureName)}State.loaded({required dynamic data})
      : this(status: ${_toPascalCase(featureName)}Status.loaded, data: data);

  factory ${_toPascalCase(featureName)}State.error({required String message}) =>
      ${_toPascalCase(featureName)}State(status: ${_toPascalCase(featureName)}Status.error, errorMessage: message);

  bool get isLoading => status == ${_toPascalCase(featureName)}Status.loading;
  bool get isLoaded => status == ${_toPascalCase(featureName)}Status.loaded;
  bool get isError => status == ${_toPascalCase(featureName)}Status.error;
}
''';

  /// Generate Provider pattern boilerplate
  ///
  /// Returns a complete Provider pattern implementation using the provider package
  /// with ChangeNotifier for the feature.
  ///
  /// The generated code includes:
  /// - ChangeNotifier-based provider class
  /// - State management with getters
  /// - Error handling
  /// - Reset functionality
  ///
  /// Returns: Complete Provider boilerplate code as a String
  String generateProviderBoilerplate() =>
      '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ${_toPascalCase(featureName)}Provider extends ChangeNotifier {
  bool _isLoading = false;
  dynamic _data;
  String? _error;

  bool get isLoading => _isLoading;
  dynamic get data => _data;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement your logic here
      _data = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _data = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
''';

  /// Generate Entity boilerplate
  ///
  /// Returns a domain layer entity class with equality operators and toString.
  /// Entities represent pure business domain models independent of frameworks.
  ///
  /// The generated code includes:
  /// - Entity class with required fields
  /// - Equality operator (==)
  /// - Hash code implementation
  /// - toString method
  ///
  /// Returns: Complete entity class as a String
  String generateEntityBoilerplate() =>
      '''
class ${_toPascalCase(featureName)}Entity {
  final String id;
  final String name;
  // TODO: Add more fields as needed

  ${_toPascalCase(featureName)}Entity({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${_toPascalCase(featureName)}Entity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => '${_toPascalCase(featureName)}Entity(id: \$id, name: \$name)';
}
''';

  /// Generate Model boilerplate
  ///
  /// Returns a data layer model class that extends the entity and adds
  /// JSON serialization capabilities using json_annotation.
  ///
  /// The generated code includes:
  /// - Model class extending entity
  /// - fromJson factory constructor
  /// - toJson method
  /// - fromEntity factory constructor
  ///
  /// Returns: Complete model class as a String
  String generateModelBoilerplate() =>
      '''
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/${_toSnakeCase(featureName)}_entity.dart';

part '${_toSnakeCase(featureName)}_model.g.dart';

@JsonSerializable()
class ${_toPascalCase(featureName)}Model extends ${_toPascalCase(featureName)}Entity {
  ${_toPascalCase(featureName)}Model({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory ${_toPascalCase(featureName)}Model.fromJson(Map<String, dynamic> json) =>
      _\$${_toPascalCase(featureName)}ModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${_toPascalCase(featureName)}ModelToJson(this);

  factory ${_toPascalCase(featureName)}Model.fromEntity(${_toPascalCase(featureName)}Entity entity) {
    return ${_toPascalCase(featureName)}Model(
      id: entity.id,
      name: entity.name,
    );
  }
}
''';

  /// Generate Repository boilerplate
  ///
  /// Returns a repository implementation that coordinates between data sources
  /// and domain layer, implementing network connectivity checks.
  ///
  /// The generated code includes:
  /// - Repository implementation class
  /// - Data source integration
  /// - Network connectivity handling
  /// - Either/Failure pattern for error handling
  ///
  /// Returns: Complete repository implementation as a String
  String generateRepositoryBoilerplate() =>
      '''
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/${_toSnakeCase(featureName)}_entity.dart';
import '../../domain/repositories/${_toSnakeCase(featureName)}_repository.dart';
import '../datasources/${_toSnakeCase(featureName)}_remote_datasource.dart';
import '../models/${_toSnakeCase(featureName)}_model.dart';

class ${_toPascalCase(featureName)}RepositoryImpl implements ${_toPascalCase(featureName)}Repository {
  final ${_toPascalCase(featureName)}RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ${_toPascalCase(featureName)}RepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ${_toPascalCase(featureName)}Entity>> get${_toPascalCase(featureName)}() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDatasource.get${_toPascalCase(featureName)}();
        return Right(remoteData);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
''';

  /// Generate Remote Datasource boilerplate
  String generateRemoteDatasourceBoilerplate() =>
      '''
import '../models/${_toSnakeCase(featureName)}_model.dart';

abstract class ${_toPascalCase(featureName)}RemoteDatasource {
  Future<${_toPascalCase(featureName)}Model> get${_toPascalCase(featureName)}();
}

class ${_toPascalCase(featureName)}RemoteDatasourceImpl implements ${_toPascalCase(featureName)}RemoteDatasource {
  // TODO: Add HTTP client or API service

  @override
  Future<${_toPascalCase(featureName)}Model> get${_toPascalCase(featureName)}() async {
    // TODO: Implement API call
    throw UnimplementedError('Implement API call');
  }
}
''';

  /// Generate Repository contract boilerplate
  String generateRepositoryContractBoilerplate() =>
      '''
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/${_toSnakeCase(featureName)}_entity.dart';

abstract class ${_toPascalCase(featureName)}Repository {
  Future<Either<Failure, ${_toPascalCase(featureName)}Entity>> get${_toPascalCase(featureName)}();
}
''';

  /// Generate Use Case boilerplate
  String generateUsecaseBoilerplate() =>
      '''
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/${_toSnakeCase(featureName)}_entity.dart';
import '../repositories/${_toSnakeCase(featureName)}_repository.dart';

class Get${_toPascalCase(featureName)}Usecase {
  final ${_toPascalCase(featureName)}Repository repository;

  Get${_toPascalCase(featureName)}Usecase({required this.repository});

  Future<Either<Failure, ${_toPascalCase(featureName)}Entity>> call() async {
    return await repository.get${_toPascalCase(featureName)}();
  }
}
''';

  /// Generate Page/Screen boilerplate
  String generatePageBoilerplate() =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ${_toPascalCase(featureName)}Page extends StatelessWidget {
  static const String routeName = '/${_toKebabCase(featureName)}';

  const ${_toPascalCase(featureName)}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${_toPascalCase(featureName)}Bloc()..add(const ${_toPascalCase(featureName)}InitialEvent()),
      child: const ${_toPascalCase(featureName)}View(),
    );
  }
}

class ${_toPascalCase(featureName)}View extends StatelessWidget {
  const ${_toPascalCase(featureName)}View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${_toPascalCase(featureName)}'),
      ),
      body: BlocBuilder<${_toPascalCase(featureName)}Bloc, ${_toPascalCase(featureName)}State>(
        builder: (context, state) {
          if (state is ${_toPascalCase(featureName)}Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ${_toPascalCase(featureName)}Error) {
            return Center(child: Text('Error: \${state.message}'));
          }

          if (state is ${_toPascalCase(featureName)}Loaded) {
            return const Center(child: Text('Data Loaded'));
          }

          return const SizedBox.expand();
        },
      ),
    );
  }
}
''';

  /// Get boilerplate for specific type
  ///
  /// Returns the appropriate boilerplate code for the given type.
  /// Supports all major code components in clean architecture.
  ///
  /// Parameters:
  ///   - type: The type of boilerplate to generate. Options:
  ///     - 'bloc': Complete BLoC pattern
  ///     - 'bloc_event': BLoC events only
  ///     - 'bloc_state': BLoC states only
  ///     - 'riverpod': Riverpod state management
  ///     - 'provider': Provider state management
  ///     - 'entity': Domain entity
  ///     - 'model': Data model
  ///     - 'repository': Repository implementation
  ///     - 'repository_contract': Repository abstract class
  ///     - 'datasource': Remote data source
  ///     - 'usecase': Use case/interactor
  ///     - 'page': Screen/page widget
  ///
  /// Returns: Boilerplate code as a string, empty string if type not found
  ///
  /// Example:
  /// ```dart
  /// final code = generator.getBoilerplateFor('bloc');
  /// final entity = generator.getBoilerplateFor('entity');
  /// ```
  String getBoilerplateFor(String type) {
    switch (type) {
      case 'bloc':
        return generateBlocBoilerplate();
      case 'bloc_event':
        return generateBlocEventBoilerplate();
      case 'bloc_state':
        return generateBlocStateBoilerplate();
      case 'riverpod':
        return generateRiverpodBoilerplate();
      case 'provider':
        return generateProviderBoilerplate();
      case 'entity':
        return generateEntityBoilerplate();
      case 'model':
        return generateModelBoilerplate();
      case 'repository':
        return generateRepositoryBoilerplate();
      case 'repository_contract':
        return generateRepositoryContractBoilerplate();
      case 'datasource':
        return generateRemoteDatasourceBoilerplate();
      case 'usecase':
        return generateUsecaseBoilerplate();
      case 'page':
        return generatePageBoilerplate();
      default:
        return '';
    }
  }

  /// Convert snake_case or camelCase string to PascalCase
  ///
  /// Splits the string by underscores, capitalizes each word, and joins.
  /// Used for class name generation.
  ///
  /// Example:
  /// ```dart
  /// _toPascalCase('user_profile'); // Returns 'UserProfile'
  /// _toPascalCase('myVariable'); // Returns 'Myvariable'
  /// ```
  String _toPascalCase(String str) {
    return str
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join();
  }

  /// Convert any case string to camelCase
  ///
  /// First converts to PascalCase, then lowercases the first character.
  /// Used for variable and property names.
  ///
  /// Example:
  /// ```dart
  /// _toCamelCase('user_profile'); // Returns 'userProfile'
  /// _toCamelCase('UserProfile'); // Returns 'userProfile'
  /// ```
  String _toCamelCase(String str) {
    final pascal = _toPascalCase(str);
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Convert any case string to snake_case
  ///
  /// Inserts underscores before uppercase letters and lowercases everything.
  /// Used for file names and constants.
  ///
  /// Example:
  /// ```dart
  /// _toSnakeCase('UserProfile'); // Returns 'user_profile'
  /// _toSnakeCase('userProfile'); // Returns 'user_profile'
  /// ```
  String _toSnakeCase(String str) {
    return str
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_\${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst('_', '')
        .toLowerCase();
  }

  /// Convert any case string to kebab-case
  ///
  /// Converts to snake_case first, then replaces underscores with hyphens.
  /// Used for route names and URLs.
  ///
  /// Example:
  /// ```dart
  /// _toKebabCase('UserProfile'); // Returns 'user-profile'
  /// _toKebabCase('userProfile'); // Returns 'user-profile'
  /// ```
  String _toKebabCase(String str) {
    return _toSnakeCase(str).replaceAll('_', '-');
  }
}
