# Environment Setup Guide

## Overview

Flutter Architect AI requires a Groq API key to enable AI-powered project generation. This guide explains how to set up environment variables for local development and production use.

## Local Development Setup

### Step 1: Get Your Groq API Key

1. Visit https://console.groq.com/keys
2. Sign up for a free account (if you don't have one)
3. Create a new API key
4. Copy the API key

### Step 2: Create .env File

Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

### Step 3: Add Your API Key

Edit `.env` and replace `your_groq_api_key_here`:

```bash
GROQ_API_KEY=gsk_YOUR_ACTUAL_API_KEY_HERE
```

### Step 4: Verify Setup

Test that the configuration loads:

```bash
dart run bin/flutter_architect_ai.dart "Test app description"
```

---

## GitHub Environments Setup (Recommended)

GitHub Environments provide better organization and protection rules for different deployment stages.

### Step 1: Create 'development' Environment

1. Go to your repository:
   ```
   https://github.com/prathameshdot/flutter_architect_ai/settings/environments
   ```

2. Click **New environment**

3. Name it **`development`**

4. Click **Configure environment**

### Step 2: Add Environment Secrets

In the **development** environment, add these secrets:

| Name | Value |
|------|-------|
| `GROQ_API_KEY` | `gsk_YOUR_ACTUAL_KEY` |
| `APP_VERSION` | `1.0.0` |
| `LOG_LEVEL` | `info` |

### Step 3: (Optional) Configure Protection Rules

For production safety:

1. Enable **Required reviewers** - Require approval before deployments
2. Set **Wait timer** - Wait 1-5 minutes before allowing deployment
3. Enable **Custom rules** - Use GitHub Apps for additional validation

### Step 4: Configure Deployment Branches

To limit which branches can deploy:

1. Under "Deployment branches and tags"
2. Select branch policy: "Protected branches only" or "Selected branches"
3. Add: `main`, `develop`

---

## Priority Order: How Environment Variables Are Loaded

The application loads environment variables in this order (first match wins):

```
1. GitHub Actions Secrets/Environment variables
   └─ Used during CI/CD pipeline
   └─ Set in Settings > Environments > development

2. System Environment Variables  
   └─ Docker environment variables
   └─ Heroku/Cloud deployment variables
   └─ Terminal environment variables

3. .env file (Local Development)
   └─ Read from `.env` file in project root
   └─ Used for local development

4. Default Values
   └─ Fallback values if nothing else is set
   └─ APP_VERSION: 1.0.0
   └─ LOG_LEVEL: INFO
```

---

### Step 1: Add Repository Secrets

1. Go to your GitHub repository:
   ```
   https://github.com/prathameshdot/flutter_architect_ai
   ```

2. Click **Settings** → **Secrets and variables** → **Actions**

3. Click **New repository secret**

4. Add the following secrets:

   **Secret Name:** `GROQ_API_KEY`
   **Secret Value:** `gsk_YOUR_ACTUAL_KEY`

   **Secret Name:** `APP_VERSION`
   **Secret Value:** `1.0.0`

   **Secret Name:** `LOG_LEVEL`
   **Secret Value:** `INFO`

### Step 2: Verify Secrets Are Set

```bash
# List all secrets (they won't show the values)
gh secret list --repo prathameshdot/flutter_architect_ai
```

---

## Using Environment Variables in CI/CD

### GitHub Actions Workflow Example

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: 3.1.0
      
      - name: Install dependencies
        run: dart pub get
      
      - name: Run tests
        env:
          GROQ_API_KEY: ${{ secrets.GROQ_API_KEY }}
          LOG_LEVEL: ${{ secrets.LOG_LEVEL }}
        run: dart test
      
      - name: Analyze
        run: dart analyze
```

---

## Environment Variables Reference

### Required Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `GROQ_API_KEY` | Groq AI API authentication | `gsk_xxxxxxxxxxxxx` |

### Optional Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `APP_VERSION` | Application version | `1.0.0` |
| `LOG_LEVEL` | Logging verbosity | `INFO` |
| `DEBUG` | Enable debug mode | `false` |
| `CUSTOM_OUTPUT_DIR` | Custom output directory | System temp |
| `AI_MODEL` | AI model to use | `mixtral-8x7b-32768` |
| `API_TIMEOUT` | API request timeout (seconds) | `30` |

---

## Loading Environment Variables

### In Your Dart Code

```dart
import 'package:dotenv/dotenv.dart';

void main() async {
  // Load .env file
  await dotenv.load(fileName: '.env');
  
  // Access variables
  final apiKey = dotenv.env['GROQ_API_KEY'];
  final version = dotenv.env['APP_VERSION'];
  
  print('API Key loaded: ${apiKey != null}');
}
```

### Using EnvironmentConfig Class

The tool includes a built-in `EnvironmentConfig` class:

```dart
import 'package:flutter_architect_ai/config/environment_config.dart';

void main() async {
  await EnvironmentConfig.initialize();
  
  final apiKey = EnvironmentConfig.groqApiKey;
  final logLevel = EnvironmentConfig.logLevel;
}
```

---

## Security Best Practices

### DO's ✓

- Use GitHub Secrets for sensitive data
- Create a `.env.example` with placeholder values
- Add `.env` to `.gitignore`
- Rotate API keys regularly
- Use environment-specific configurations
- Document all required environment variables

### DON'Ts ✗

- Never commit actual `.env` file
- Never hardcode API keys in code
- Never share API keys via email or chat
- Never post secrets in issues or PRs
- Never use weak or expired keys

### .gitignore Configuration

Ensure `.env` is ignored:

```bash
# Environment variables
.env
.env.local
.env.*.local
*.key
*.pem
```

---

## Groq API Key Management

### Free Tier Limits

- **Rate Limit:** 30 requests per minute
- **Models Available:** Multiple state-of-the-art models
- **Cost:** Free tier available
- **No Credit Card Required:** Initial free trial

### Getting Higher Limits

1. Visit https://console.groq.com
2. Upgrade your account for production use
3. Contact support for higher rate limits

### Monitoring Your Usage

```bash
# Monitor API usage at
https://console.groq.com/dashboard
```

---

## Troubleshooting

### Issue: "API Key not found"

**Solution:**
```bash
# Make sure .env file exists
ls -la .env

# Verify GROQ_API_KEY is set
cat .env | grep GROQ_API_KEY
```

### Issue: "Invalid API Key"

**Solution:**
```bash
# Re-generate your API key at https://console.groq.com/keys
# Update .env file with new key
# Restart the application
```

### Issue: "Rate limit exceeded"

**Solution:**
- Wait a few minutes before retrying
- Upgrade to a higher tier at https://console.groq.com
- Use `--no-ai` flag to disable AI generation

### Issue: "GitHub Secret not accessible in workflow"

**Solution:**
```yaml
# Make sure secret is passed to job environment
env:
  GROQ_API_KEY: ${{ secrets.GROQ_API_KEY }}
```

---

## Production Deployment

### For Heroku/Docker

Dockerfile example:

```dockerfile
FROM google/dart:latest

WORKDIR /app

COPY . .

RUN dart pub get

ENV GROQ_API_KEY=${GROQ_API_KEY}
ENV LOG_LEVEL=INFO

ENTRYPOINT ["dart", "bin/flutter_architect_ai.dart"]
```

Deploy:

```bash
# Set environment variable
heroku config:set GROQ_API_KEY=gsk_xxxxx

# Deploy
git push heroku main
```

### For Cloud Computing Platforms

#### Google Cloud Run

```bash
gcloud run deploy flutter-architect-ai \
  --set-env-vars GROQ_API_KEY=gsk_xxxxx \
  --source .
```

#### AWS Lambda

Create environment variables in Lambda console:
- `GROQ_API_KEY`
- `LOG_LEVEL`

#### Azure Functions

```bash
az functionapp config appsettings set \
  --name myFunctionApp \
  --resource-group myResourceGroup \
  --settings "GROQ_API_KEY=gsk_xxxxx"
```

---

## Support

Need help with environment setup?

- GitHub Issues: https://github.com/prathameshdot/flutter_architect_ai/issues
- Groq Support: https://console.groq.com/docs
- Flutter Architect AI Docs: https://github.com/prathameshdot/flutter_architect_ai/blob/main/DOCUMENTATION.md

---

## Checklist

Before deploying:

- [ ] `.env` file created with valid `GROQ_API_KEY`
- [ ] `.env` file added to `.gitignore`
- [ ] GitHub Secrets configured
- [ ] Local testing successful
- [ ] CI/CD workflow includes environment variables
- [ ] No API keys hardcoded in source code
- [ ] Documentation updated
- [ ] Team members notified of environment setup
