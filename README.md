# DevMind - Your Developer Companion

A modern Flutter web application for managing code snippets, planning development tasks, and future AI integration.

## Features

### 🎯 Current Features
- **Code Snippets Manager**: Store, organize, and manage your code snippets with syntax highlighting
- **Task Planner**: Plan and track your development tasks with due dates and status tracking
- **Responsive Design**: Beautiful, modern UI that works on all screen sizes
- **Dark/Light Theme**: Automatic theme switching with manual override

### 🚀 Upcoming Features
- AI-powered code assistance
- Advanced search and filtering
- Code snippet sharing
- Cloud synchronization
- Syntax highlighting for multiple languages

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: GetX
- **Local Storage**: Hive
- **UI Components**: Material 3 Design
- **Responsive Design**: flutter_screenutil
- **Typography**: Google Fonts

## Project Structure

```
lib/
├── app/
│   ├── modules/          # Feature modules
│   │   ├── home/         # Home screen
│   │   ├── snippets/     # Code snippets feature
│   │   └── planner/      # Task planner feature
│   ├── routes/           # Navigation routes
│   ├── theme/            # App themes
│   └── data/             # Data models and services
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository
```bash
git clone <your-repo-url>
cd devmind
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
# For web
flutter run -d chrome

# For desktop
flutter run -d macos  # or windows/linux
```

## Usage

### Code Snippets
1. Navigate to the Code Snippets section
2. Click the "+" button to add a new snippet
3. Enter title, language, and code
4. View, copy, or delete snippets as needed

### Task Planner
1. Navigate to the Planner section
2. Click the "+" button to create a new task
3. Add title, description, and optional due date
4. Mark tasks as complete or delete them

## Development

### Adding New Features
1. Create a new module in `lib/app/modules/`
2. Add routes in `lib/app/routes/`
3. Create controllers using GetX
4. Implement views with responsive design

### Building for Production

```bash
# Web
flutter build web

# Desktop
flutter build macos  # or windows/linux
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Contact

For questions or feedback, please open an issue on GitHub.
# Devmind_web
