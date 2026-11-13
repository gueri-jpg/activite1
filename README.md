# Flutter Writer Management System

A cross-platform writer management application built with **Flutter and Dart**, designed to simplify the creation, organization, editing, and deletion of writer records.

## Features

- **Create:** Register writers with their first name, last name, and email address.
- **Read:** View all registered writers in an organized directory.
- **Update:** Edit existing writer information.
- **Delete:** Remove writer records with confirmation.
- **Validation:** Prevent duplicate email addresses and require all fields.
- **User Experience:** Material Design 3 interface with visual feedback and dynamic record counts.

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **UI:** Material Design 3
- **State Management:** StatefulWidget and setState
- **Storage:** In-memory data management (persistent storage planned)

## Getting Started

### Prerequisites

Install the Flutter SDK and configure your development environment.

### Installation

```bash
git clone https://github.com/gueri-jpg/activite1.git
cd activite1
flutter pub get
flutter run
```

## Project Architecture

The application separates its main responsibilities into three components:

- `lib/main.dart` — Application interface and user interactions.
- `lib/modeles/redacteur.dart` — Writer data model.
- `lib/database/database_manager.dart` — CRUD operations and in-memory record management.

## Current Limitations

This is an educational prototype. Records are stored temporarily in memory and are not preserved after the application restarts. The current user interface is in French.

## Future Improvements

- [ ] Integrate SQLite for persistent storage.
- [ ] Implement stronger input validation.
- [ ] Add automated CRUD tests.
- [ ] Improve responsive layouts.
- [ ] Introduce search and filtering.
- [ ] Support multiple interface languages.

## Author

[**gueri-jpg**](https://github.com/gueri-jpg)

## Project Repository

https://github.com/gueri-jpg/activite1
