# 📚 Flutter Architect AI - Complete Documentation

**AI-Powered Flutter Clean Architecture Project Generator**

## Table of Contents

1. [Installation](#installation)
2. [Quick Start](#quick-start)
3. [Command Reference](#command-reference)
4. [Configuration](#configuration)
5. [Architecture](#architecture)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)
8. [Contributing](#contributing)

---

## Installation

### From Pub.dev
```bash
dart pub global activate flutter_architect_ai
```

### From Source
```bash
git clone https://github.com/yourusername/flutter_architect_ai.git
cd flutter_architect_ai
dart pub global activate --source path .
```

### Verify Installation
```bash
flutter_architect_ai --version
flutter_architect_ai --help
```

---

## Quick Start

### Basic Project
```bash
flutter_architect_ai create -n my_app
```

### AI-Generated Architecture
```bash
flutter_architect_ai create \
  -n ecommerce_app \
  -d "Full ecommerce platform with product catalog, shopping cart, order management, and payments" \
  --ai-generate \
  -s bloc \
  -b firebase
```

---

## Command Reference

### Help
```bash
flutter_architect_ai help
flutter_architect_ai create --help
```

### Version
```bash
flutter_architect_ai version
```

### Create Command

```bash
flutter_architect_ai create [options]
```

**Required Options:**
- `-n, --name` - Project name

**Optional Options:**
- `-d, --description` - Project description for AI
- `-s, --state` - State management (default: bloc)
- `-b, --backend` - Backend type (default: rest_api)
- `--ui` - UI framework (default: material)
- `--with-auth` - Include auth (default: true)
- `--with-db` - Include database (default: true)
- `--ai-generate` - Use AI analysis
- `-p, --path` - Output directory

---

## Configuration

### State Management Selection

#### BLoC Pattern
Best for: Large enterprise apps, complex state
```bash
flutter_architect_ai create -n app -s bloc
```

#### Riverpod
Best for: Modern reactive apps, functional approach
```bash
flutter_architect_ai create -n app -s riverpod
```

#### Provider
Best for: Beginners, simple to medium projects
```bash
flutter_architect_ai create -n app -s provider
```

#### GetX
Best for: All-in-one solution with routing
```bash
flutter_architect_ai create -n app -s getx
```

### Backend Configuration

#### Firebase
Real-time database, authentication, storage
```bash
flutter_architect_ai create \
  -n app \
  -b firebase \
  --with-auth
```

#### Supabase
PostgreSQL backend with real-time
```bash
flutter_architect_ai create \
  -n app \
  -b supabase \
  --with-auth
```

#### REST API
Traditional HTTP backend
```bash
flutter_architect_ai create \
  -n app \
  -b rest_api
```

#### GraphQL
Modern query language
```bash
flutter_architect_ai create \
  -n app \
  -b graphql
```

---

## Architecture

### Clean Architecture Principles

The generated project follows these principles:

**Separation of Concerns**
- Clear layer boundaries
- Independent testability
- Framework agnostic business logic

**Dependency Inversion**
- Interfaces (contracts) define dependencies
- Implementation depends on abstractions
- Easy to swap implementations

**Single Responsibility**
- Each class has one reason to change
- Clear, focused responsibilities

### Layer Structure

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│        (UI, BLoCs, Pages)               │
└────────────────┬────────────────────────┘
                 │ depends on
                 ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│   (Business Logic, Entities, Usecases)  │
└────────────────┬────────────────────────┘
                 │ depends on (via interfaces)
                 ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│    (Repositories, DataSources)          │
└─────────────────────────────────────────┘
```

### Feature Structure

Each feature follows the same pattern:

```
feature/
├── data/
│   ├── datasources/
│   │   ├── remote_datasource.dart      # API calls
│   │   └── local_datasource.dart       # Cache/DB
│   ├── models/                          # API-specific models
│   └── repositories/                    # Implementations
├── domain/
│   ├── entities/                        # Core models
│   ├── repositories/                    # Contracts
│   └── usecases/                        # Business logic
└── presentation/
    ├── bloc/ / riverpod/                # State management
    ├── pages/                           # Screens
    ├── widgets/                         # Components
    └── routes/                          # Navigation
```

---

## Examples

### Example 1: E-Commerce App

```bash
flutter_architect_ai create \
  -n shop_hub \
  -d "Modern e-commerce platform with product browsing, shopping cart, checkout, order tracking, and user profile management" \
  --ai-generate \
  -s bloc \
  -b firebase \
  --with-auth \
  --with-db \
  -p ~/flutter_projects
```

**Generated Features:**
- auth
- products
- cart
- orders
- payments
- notifications
- profile
- search

**Generated Packages:**
- firebase_core, firebase_auth, cloud_firestore
- flutter_bloc, bloc
- cached_network_image, flutter_svg
- dio, retrofit
- hive, hive_flutter (for caching)

---

### Example 2: Social Media App

```bash
flutter_architect_ai create \
  -n social_connect \
  -d "Social networking platform with user profiles, feed, messaging, likes, comments, and followers" \
  --ai-generate \
  -s riverpod \
  -b supabase \
  --with-auth \
  --with-db
```

**Generated Features:**
- auth
- profiles
- feed
- messaging
- notifications
- search

---

### Example 3: Task Management App

```bash
flutter_architect_ai create \
  -n task_master \
  -d "Task/todo management app with list creation, task assignment, reminders, and collaboration" \
  --ai-generate \
  -s provider \
  -b rest_api \
  --with-auth \
  --with-db
```

---

### Example 4: Weather App (Simple)

```bash
flutter_architect_ai create \
  -n weather_mate \
  -s bloc \
  -b rest_api \
  --with-db
```

**Features Generated:**
- home
- search
- notifications

---

## Post-Generation Setup

### 1. Navigate to Project
```bash
cd my_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
# For projects using build_runner (BLoC, Riverpod)
flutter pub run build_runner build
```

### 4. Configure Environment
Edit `lib/config/environment/env_config.dart`:
```dart
static Future<void> initialize(Flavor flavor) async {
  _flavor = flavor;

  switch (flavor) {
    case Flavor.development:
      _baseUrl = 'https://dev-api.example.com';
      // Other dev configs
      break;
    // ... other flavors
  }
}
```

### 5. Set Up Firebase (if used)
```bash
flutterfire configure
```

### 6. Run the App
```bash
flutter run
```

---

## Adding New Features

After project generation, add new features:

### Manual Method

1. Create feature directory:
```bash
mkdir -p lib/features/new_feature/{data,domain,presentation}
mkdir -p lib/features/new_feature/data/{datasources,models,repositories}
mkdir -p lib/features/new_feature/domain/{entities,repositories,usecases}
mkdir -p lib/features/new_feature/presentation/{bloc,pages,widgets}
```

2. Follow the generated patterns for each layer

### Using the Generator Programmatically

```dart
import 'package:flutter_architect_ai/flutter_architect_ai.dart';

void main() {
  final generator = BoilerplateGenerator(
    featureName: 'new_feature',
    stateManagement: 'bloc',
  );

  // Generate boilerplate
  final blocCode = generator.getBoilerplateFor('bloc');
  final entityCode = generator.getBoilerplateFor('entity');
  final pageCode = generator.getBoilerplateFor('page');
  
  // Write to files...
}
```

---

## Folder Structure Explained

### Core Directory (`lib/core/`)

**constants/** - Application-wide constants
```dart
class AppConstants {
  static const String apiBaseUrl = 'https://api.example.com';
  static const int pageSize = 20;
}
```

**error/** - Exception and failure handling
```dart
abstract class AppException implements Exception { }
abstract class Failure { }
```

**network/** - API client and networking
```dart
class ApiClient {
  Future<Response> get(String endpoint) { }
}
```

**services/** - Singletons (logger, analytics, storage)
```dart
class LoggerService { }
class AnalyticsService { }
class StorageService { }
```

**theme/** - App colors, text styles, themes
```dart
class AppColors { }
class AppTheme { }
```

**utils/** - Helper functions and extensions
```dart
extension StringX on String { }
String toPascalCase(String str) { }
```

**widgets/** - Reusable custom widgets
```dart
class AppButton extends StatelessWidget { }
class AppTextField extends StatelessWidget { }
```

### Features Directory (`lib/features/`)

Each feature contains:

**data/datasources** - External data access
```dart
abstract class RemoteDatasource { }
abstract class LocalDatasource { }
```

**data/models** - API-specific models
```dart
@JsonSerializable()
class UserModel extends UserEntity { }
```

**domain/entities** - Pure business models
```dart
class UserEntity {
  final String id;
  final String name;
}
```

**domain/usecases** - Business logic
```dart
class GetUserUsecase {
  Future<Either<Failure, UserEntity>> call(String userId) { }
}
```

**presentation/bloc** - State management
```dart
class UserBloc extends Bloc<UserEvent, UserState> { }
```

---

## Environment Management

### Multiple Flavors

Run different app versions:

```bash
# Development
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_production.dart
```

Each entrypoint initializes different environments:

```dart
// main_dev.dart
void main() async {
  await Environment.initialize(Flavor.development);
  runApp(const MyApp());
}
```

---

## Dependency Injection

### GetIt Service Locator

Register dependencies in `lib/config/di/service_locator.dart`:

```dart
void initializeServiceLocator() {
  // Services
  getIt.registerSingleton<LoggerService>(LoggerService());
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Repositories
  getIt.registerSingleton<UserRepository>(
    UserRepository(
      remoteDatasource: getIt<UserRemoteDatasource>(),
      localDatasource: getIt<UserLocalDatasource>(),
    ),
  );
  
  // Usecases
  getIt.registerSingleton<GetUserUsecase>(
    GetUserUsecase(repository: getIt<UserRepository>()),
  );
  
  // BLoCs
  getIt.registerSingleton<UserBloc>(
    UserBloc(usecase: getIt<GetUserUsecase>()),
  );
}
```

Use in your code:
```dart
final userBloc = getIt<UserBloc>();
```

---

## Testing

### Unit Tests

Test use cases and business logic:

```bash
flutter test
```

### Integration Tests

Test entire features:

```bash
flutter test integration_test/
```

---

## Troubleshooting

### Issue: "Invalid project name"
```
Solution: Use only lowercase letters, numbers, underscores

CORRECT: flutter_architect_ai create -n my_app
WRONG: flutter_architect_ai create -n "My App"
WRONG: flutter_architect_ai create -n MyApp
```

### Issue: "Directory already exists"
```
Solution: Delete existing directory or use different name

flutter_architect_ai create -n my_app_v2
```

### Issue: "Groq API Error"
```
Solution: Check internet connection and API key

The API key is embedded in the tool. For production:
1. Move API key to environment file
2. Update in groq_ai_service.dart
```

### Issue: "build_runner errors"
```
Solution: Clean and rebuild

flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: "Dependency conflicts"
```
Solution: Update dependencies

flutter pub upgrade
flutter pub get
```

---

## Best Practices

### 1. Write Pure Functions
Logic that doesn't depend on UI or external dependencies

### 2. Use Repositories
Abstracts data access from business logic

### 3. Implement Error Handling
Use Either<Failure, Success> pattern

### 4. Document Code
Add comments for complex logic

### 5. Follow Naming Conventions
- Files: snake_case.dart
- Classes: PascalCase
- Variables: camelCase
- Constants: camelCase

### 6. Keep Layers Separated
Don't import presentation layer in domain layer

### 7. Use Dependency Injection
Inject dependencies rather than creating them

---

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Create Pull Request

---

## Support

- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions
- **Email:** support@example.com

---

**Built with ❤️  for Flutter developers**
