# Contributing to Price Ghost

Thank you for your interest in contributing to Price Ghost! This document provides guidelines for contributing to the project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Creating Issues](#creating-issues)
- [Pull Requests](#pull-requests)
- [Code Style](#code-style)
- [Testing](#testing)

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/price-ghost.git`
3. Add upstream remote: `git remote add upstream https://github.com/rlyons/price-ghost.git`
4. Create a feature branch: `git checkout -b feature/your-feature-name`

## Development Setup

### Prerequisites

- Flutter 3.24 or higher
- Dart 3.5 or higher
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Set up environment variables:
   ```bash
   # Copy .env.example to .env and fill in your API keys
   cp .env.example .env
   ```

3. Run the app:
   ```bash
   # With Keepa API key
   flutter run --dart-define=KEEPA_API_KEY=your_key_here
   
   # Demo mode (no API key required)
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/keepa_service_test.dart

# Run tests with coverage
flutter test --coverage
```

## Creating Issues

We use issue templates to help organize and track work. When creating an issue:

1. **Check existing issues** first to avoid duplicates
2. **Choose the appropriate template**:
   - Bug Report: For reporting bugs and issues
   - Feature Request: For proposing new features
   - Documentation: For documentation improvements
   - Question: For asking questions about the project

3. **Provide detailed information**:
   - Clear, descriptive title
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Screenshots or code samples when applicable
   - Device/OS information for platform-specific issues

### Archived Issues

Detailed feature implementation plans are archived in `docs/issue-archives/`. These provide comprehensive context for major features and can be used as reference when working on related issues.

## Pull Requests

### Before Submitting

1. **Ensure your code follows our style guidelines**
2. **Add tests** for new functionality
3. **Update documentation** as needed
4. **Run tests locally** to ensure they pass
5. **Consider impact on images/ads** if touching UI

### PR Process

1. Update your fork:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

3. Create a Pull Request from your fork to the main repository

4. Fill out the PR template completely

5. Link related issues using keywords (e.g., "Closes #123", "Fixes #456")

6. Wait for review and address any feedback

### PR Template

When you create a PR, you'll see a template with checkboxes. Please complete all relevant sections:

- Description of changes
- Type of change (bug fix, new feature, etc.)
- Testing checklist
- Documentation updates
- UI/monetization considerations

## Code Style

### Dart/Flutter Guidelines

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use `flutter format` to format your code
- Run `flutter analyze` and fix any warnings
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Riverpod Conventions

- Use `Riverpod 3.0` patterns (no deprecated APIs)
- Place providers in `lib/providers/`
- Use `StateNotifier` for complex state
- Prefer `FutureProvider.family` for parameterized async data

### File Organization

- `lib/screens/`: Full-screen pages
- `lib/widgets/`: Reusable UI components
- `lib/services/`: Business logic and API integrations
- `lib/providers/`: Riverpod state providers
- `lib/models/`: Data models (if needed)
- `test/`: Mirror structure of `lib/`

## Testing

### Test Requirements

- **Unit tests** for all services (`lib/services/`)
- **Widget tests** for complex widgets
- **Integration tests** for critical user flows (scanner → detail → watchlist)
- **Mock external dependencies** (API calls, storage, etc.)

### Writing Tests

```dart
// Example unit test
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_ghost/services/keepa_service.dart';

void main() {
  group('KeepaService', () {
    test('predictBuySignal returns correct signal', () {
      final service = KeepaService(apiKey: 'test');
      // ... test implementation
    });
  });
}
```

## Security

### API Keys

- **Never commit API keys** to the repository
- Use `--dart-define` for runtime configuration
- Store keys in `.env` (ignored by git)
- Document required keys in `.env.example`

### Sensitive Data

- Don't log sensitive information
- Sanitize user data before analytics
- Follow platform guidelines for data storage

## Questions?

If you have questions not covered here:

1. Check the [README](README.md)
2. Search existing issues
3. Create a new issue with the "Question" template
4. Join discussions in existing issues

## Developer Scripts

Helper scripts are available in `scripts/dev/`:

- `create_repo_and_push.sh`: Create GitHub repo and push code
- `create_github_issues.sh`: Create issues from archived templates

These require the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

---

Thank you for contributing to Price Ghost! 🎯📦
