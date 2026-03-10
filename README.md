# Flutter Architect AI

**AI-Powered Flutter Clean Architecture Project Generator**

An intelligent CLI tool that generates production-ready Flutter projects with clean architecture patterns using Groq AI. Simply describe your app, and let the AI create a complete project structure with all necessary boilerplate code.

---

## Key Features

### AI-Powered Architecture Generation
- Analyzes your project description using Groq AI
- Automatically recommends optimal feature structure
- Suggests appropriate packages based on your use case
- Learns from best practices in Flutter development

### Complete Project Generation
- **Clean Architecture Setup** - Proper separation of concerns
- **Pre-configured Dependencies** - All commonly used packages curated
- **State Management Ready** - Support for BLoC, Riverpod, Provider, GetX
- **Backend Integration** - Firebase, Supabase, REST API, GraphQL templates
- **Production-Ready Structure** - Follows industry best practices

### Multiple State Management Options
- **BLoC** (flutter_bloc)
- **Riverpod** (flutter_riverpod)
- **Provider**
- **GetX**

### Backend Integration Support
- **Firebase** - Real-time database, auth, storage
- **Supabase** - Open-source Firebase alternative
- **REST API** - Traditional HTTP-based backends
- **GraphQL** - Modern query language support

---

## Installation

### From Source
```bash
git clone https://github.com/yourusername/flutter_architect_ai.git
cd flutter_architect_ai
dart pub global activate --source path .
```

### Local Development
```bash
dart pub get
dart run bin/flutter_architect_ai.dart --help
```

---

## Environment Setup

### Required: Groq API Key

Flutter Architect AI requires a Groq API key for AI-powered project generation.

1. Get your API key from https://console.groq.com/keys
2. Create a `.env` file in the project root:
   ```bash
   cp .env.example .env
   ```
3. Add your API key:
   ```bash
   GROQ_API_KEY=gsk_your_api_key_here
   ```

For complete setup instructions, see [SETUP_ENVIRONMENT.md](SETUP_ENVIRONMENT.md)

---

## Quick Start

### AI-Powered Generation

```bash
flutter_architect_ai create \
  -n ecommerce_app \
  -d "Ecommerce app with products, cart, orders, and payments" \
  --ai-generate \
  -s bloc \
  -b firebase
```

### Custom Configuration

```bash
flutter_architect_ai create \
  -n my_app \
  -s riverpod \
  -b supabase \
  --with-auth \
  --with-db
```

---

## Generated Project Structure

```
my_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── error/
│   │   ├── network/
│   │   ├── services/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   ├── features/
│   │   ├── auth/
│   │   ├── products/
│   │   └── [other features]/
│   ├── config/
│   │   ├── di/
│   │   ├── environment/
│   │   └── routes/
│   ├── shared/
│   └── main.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## Architecture

**Clean Architecture with 3 Layers:**
- **Presentation** - UI, BLoCs, Pages
- **Domain** - Business logic, Use Cases, Entities
- **Data** - Repositories, Data Sources, Models

---

## Documentation

For detailed usage, examples, and advanced features, see [DOCUMENTATION.md](./DOCUMENTATION.md)

---

## License

MIT License - See LICENSE file for details

---

**Happy coding!**
