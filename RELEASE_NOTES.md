# Flutter Architect AI v1.0.0

## Overview

Flutter Architect AI is an intelligent CLI tool that generates production-ready Flutter projects with Clean Architecture patterns using Groq AI. Simply describe your app, and let the AI create a complete project structure with all necessary boilerplate code.

## What's New

### Core Features
- **AI-Powered Architecture Generation** - Analyzes your project description using Groq AI to recommend optimal feature structures
- **Complete Project Generation** - Generates clean architecture setup with pre-configured dependencies
- **Multiple State Management Options** - Support for BLoC, Riverpod, Provider, and GetX
- **Backend Integration** - Templates for Firebase, Supabase, REST API, and GraphQL
- **Production-Ready Structure** - Follows Flutter and Dart best practices

### Key Components

#### Code Generation
- Complete lib structure with 58+ Dart files
- feature-based Clean Architecture (core, config, features, shared)
- Auto-detected features from natural language descriptions
- Generated BLoCs, entities, datasources, and repositories for each feature

#### Configuration Files
- pubspec.yaml with curated dependencies
- analysis_options.yaml with comprehensive linting rules
- .gitignore for Flutter projects
- README.md with dynamic project structure
- CHANGELOG.md template

#### Supported Features
Automatic detection and generation for:
- Authentication & Profiles
- Products & Shopping Carts
- Orders & Payments
- Chat & Messaging
- Notifications & Alerts
- Search & Filtering
- Analytics & Tracking
- Ratings & Reviews
- Image Gallery

## Installation

### From pub.dev
```bash
dart pub global activate flutter_architect_ai
flutter_architect_ai --help
```

### From Source
```bash
git clone https://github.com/prathameshdot/flutter_architect_ai.git
cd flutter_architect_ai
dart pub global activate --source path .
```

## Usage

### Basic Usage
```bash
flutter_architect_ai "Build an ecommerce app with products, cart, and user authentication"
```

### Advanced Options
```bash
flutter_architect_ai \
  --output ~/projects/my_app \
  --state bloc \
  --backend rest_api \
  --with-auth \
  --with-db
```

### Command Options
- `-o, --output` - Output directory for the project
- `-s, --state` - State management (bloc, riverpod, provider, getx)
- `-b, --backend` - Backend type (rest_api, firebase, supabase, graphql)
- `--no-auth` - Exclude authentication module
- `--no-db` - Exclude database setup
- `--no-ai` - Use keyword extraction instead of AI analysis

## Generated Project Structure

```
my_app/
  lib/
    core/
      constants/
      error/
      network/
      services/
      theme/
      utils/
    features/
      [auto-generated features]
        data/domain/presentation layers
    config/
      di/
      environment/
      routes/
    shared/
    main.dart
  assets/
    images/
    icons/
    fonts/
  test/
  pubspec.yaml
  analysis_options.yaml
  README.md
```

## Architecture Pattern

Clean Architecture with three-layer separation:

### Presentation Layer
- Pages and Widgets (UI components)
- BLoC/Riverpod (state management)
- Event handlers

### Domain Layer
- Business logic
- Use cases
- Repository interfaces
- Entities

### Data Layer
- Repository implementations
- Remote/Local data sources
- Models and mappers
- API clients

## Technology Stack

- **Language** - Dart 3.0+
- **Framework** - Flutter 3.0+
- **AI** - Groq API (with fallback keyword extraction)
- **State Management** - BLoC, Riverpod, Provider, GetX
- **Architecture** - Clean Architecture

## Dependencies

Core dependencies included:
- `get_it` - Service locator/DI
- `http` - HTTP client
- `dartz` - Functional programming
- `flutter_bloc` - State management
- `uuid` - UUID generation
- `yaml` - Configuration parsing

## Minimum Requirements

- Dart SDK: 3.10.1+
- Flutter SDK: 3.0+

## Documentation

- [Full Documentation](https://github.com/prathameshdot/flutter_architect_ai/blob/main/DOCUMENTATION.md)
- [README](https://github.com/prathameshdot/flutter_architect_ai/blob/main/README.md)
- [Pub.dev Package](https://pub.dev/packages/flutter_architect_ai)

## Troubleshooting

### Issue: Flutter CLI not found
**Solution:** Ensure Flutter is in your PATH. The tool has fallback support for manual setup.

### Issue: Invalid AI response
**Solution:** Use `--no-ai` flag to use keyword extraction instead.

### Issue: Permission denied
**Solution:** The tool may need permission to create directories. Run from a suitable location.

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Support

- GitHub Issues: https://github.com/prathameshdot/flutter_architect_ai/issues
- Discussions: https://github.com/prathameshdot/flutter_architect_ai/discussions

## License

MIT License - See LICENSE file for details

## Credits

Created by Prathamesh Raut (prathameshdot)

## Version History

### Version 1.0.0
- Initial release
- Complete Clean Architecture project generation
- AI-powered feature detection
- Support for multiple state management patterns
- Configuration file generation
- Platform-specific code generation (Android, iOS, Web)

---

Thank you for using Flutter Architect AI! If you find it helpful, please consider:
- Starring the repository
- Liking the package on pub.dev
- Sharing it with the Flutter community
- Contributing improvements
