# Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
cd /Users/bdcalling/Documents/devmind
flutter pub get
```

### Step 2: Run the App
```bash
# For web (recommended)
flutter run -d chrome

# For macOS desktop
flutter run -d macos
```

### Step 3: Start Using DevMind!
The app will open in your browser. You'll see:
- **Home**: Dashboard with feature cards
- **Code Snippets**: Click to manage your code snippets
- **Planner**: Click to manage your tasks

---

## 📖 Feature Walkthroughs

### Adding a Code Snippet
1. Click on "Code Snippets" from the home screen
2. Click the "+ Add Snippet" button
3. Fill in:
   - **Title**: Name your snippet (e.g., "React useState Hook")
   - **Language**: Programming language (e.g., "JavaScript")
   - **Code**: Paste your code
4. Click "Add"
5. Your snippet is saved and displayed!

**Pro Tips:**
- Click on a snippet card to view full details
- Use the copy button to copy code to clipboard
- Delete snippets you no longer need

### Creating a Plan
1. Click on "Planner" from the home screen
2. Click the "+ Add Plan" button
3. Fill in:
   - **Title**: Task name (e.g., "Build authentication system")
   - **Description**: Details about the task
   - **Due Date**: Optional deadline
4. Click "Add"
5. Your plan is created!

**Pro Tips:**
- Check the checkbox to mark tasks complete
- Overdue tasks show a red "Overdue" badge
- Click on a plan to see full details

### Switching Themes
- Click the sun/moon icon in the top-right corner of the home screen
- The app will switch between light and dark mode
- Your preference is remembered

---

## 🎯 Common Tasks

### View All Snippets
Navigate to Snippets → See all your saved code snippets in a scrollable list

### Search (Coming Soon)
Click the search icon in the snippets/planner screens

### Copy Code
Click the copy icon on any snippet card → Code is copied to clipboard

### Delete Items
Click the delete icon → Confirm deletion → Item is removed

---

## 🛠️ Development Commands

### Run in Debug Mode
```bash
flutter run -d chrome --debug
```

### Run in Release Mode
```bash
flutter run -d chrome --release
```

### Build for Production
```bash
flutter build web --release
```

### Check for Issues
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

---

## 📁 Project Files Overview

### Main Files You'll Work With
- `lib/main.dart` - App entry point
- `lib/app/modules/snippets/` - Snippet feature
- `lib/app/modules/planner/` - Planner feature
- `lib/app/theme/app_theme.dart` - Customize colors and styles

### Configuration Files
- `pubspec.yaml` - Add new dependencies here
- `.env` - Environment variables (API keys, etc.)

---

## 🎨 Customization Guide

### Change App Colors
Edit `lib/app/theme/app_theme.dart`:
```dart
// Light theme primary color
primary: const Color(0xFF3F51B5), // Change this hex code

// Dark theme primary color
primary: const Color(0xFF7986CB), // Change this hex code
```

### Change App Name
Edit `pubspec.yaml`:
```yaml
name: devmind  # Change to your app name
```

### Add New Features
1. Create a new module in `lib/app/modules/your_feature/`
2. Add controller, view, and binding files
3. Register route in `lib/app/routes/app_pages.dart`
4. Add navigation from home screen

---

## ⚡ Performance Tips

### Web Performance
- Use `flutter run -d chrome --release` for better performance
- Enable caching in production builds
- Optimize images before adding to assets

### Desktop Performance
- Release builds are much faster than debug builds
- Use `flutter build macos --release` for production

---

## 🐛 Troubleshooting

### App Won't Run?
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

### Dependencies Error?
```bash
# Update dependencies
flutter pub upgrade
```

### Hot Reload Not Working?
- Press `r` in the terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

---

## 📚 Next Steps

### Implement Persistent Storage
Currently, data is stored in memory. To persist data:
1. Implement Hive adapters in controllers
2. Save snippets/plans to Hive boxes
3. Load data on app start

### Add AI Integration
1. Get an API key from OpenAI/Anthropic
2. Add to `.env` file
3. Implement API calls in a new service
4. Create AI assistant UI

### Deploy to Web
```bash
flutter build web --release
# Upload the build/web folder to your hosting service
```

---

## 💡 Tips for Success

1. **Start Small**: Add a few snippets and plans to test
2. **Explore the Code**: Check out the controllers to see how state management works
3. **Customize**: Change colors, fonts, and layouts to match your style
4. **Extend**: Add new features using the existing structure as a template
5. **Have Fun**: This is your personal developer tool - make it yours!

---

**Need Help?** Check the PROJECT_SUMMARY.md for detailed technical information.

**Ready to Code?** Run `flutter run -d chrome` and start building! 🚀
