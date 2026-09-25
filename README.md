# 🧠 Quizzical - Flutter Quiz Application

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-%2300B4AB.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/Provider-State_Management-blueviolet?style=for-the-badge)](https://pub.dev/packages/provider)
[![OpenTDB API](https://img.shields.io/badge/API-OpenTDB_REST-orange?style=for-the-badge)](https://opentdb.com/)

**Quizzical** is a feature-packed, responsive, and modern Flutter mobile quiz application created for the **CSE App Development Lab Exam**. The application dynamically fetches live trivia questions from the [Open Trivia Database (OpenTDB) REST API](https://opentdb.com/) using **Provider** state management, adhering to clean architecture principles and modern Dart software patterns.

---

## 📸 Demonstration

| Welcome Screen | Category Selection | Quiz Configuration | Live Quiz Engine | Results & Analytics |
| :---: | :---: | :---: | :---: | :---: |
| <img src="screenshots/welcome.jpg" width="160" /> | <img src="screenshots/categories.jpg" width="160" /> | <img src="screenshots/config.jpg" width="160" /> | <img src="screenshots/quiz.jpg" width="160" /> | <img src="screenshots/result.jpg" width="160" /> |

---

## ✨ Features

### 👋 1. Welcome Screen & Personalized Branding
- Displays personalized student branding for **Israt Jahan Tamanna**.
- Clean, eye-catching UI with custom quiz illustrations and a smooth transition to category selection.

### 📚 2. Dynamic Live Categories
- **OpenTDB API Integration**: Automatically fetches real-time trivia categories from the OpenTDB backend.
- **Custom Visual Cards**: Each category is presented with distinct pastel background colors and category-specific icons.
- **Offline & Fallback Support**: Features built-in skeleton loaders and fallback datasets to guarantee flawless operation even without an internet connection.

### ⚙️ 3. Granular Quiz Configuration
- **Question Volume Slider**: Dynamically select the exact number of questions (from 1 up to 50 questions).
- **Difficulty Selection**: Tailor your quiz challenge level (*Any Difficulty, Easy, Medium, Hard*).
- **Question Format**: Choose preferred question types (*Any Type, Multiple Choice, True / False*).
- **Config Persistence**: Saves user configuration preferences locally using `shared_preferences`.

### ⏱️ 4. Interactive Live Quiz Engine
- **Per-Question Countdown Timer**: 15-second animated timer per question with auto-advance upon expiry.
- **Immediate Answer Feedback**: Selected answer is instantly validated with visual feedback — green highlight for correct, red highlight for incorrect while automatically pointing out the right answer.
- **HTML Entity Decoding**: Uses robust `html_unescape` decoding to render mathematical symbols, quotes, and HTML special characters cleanly.
- **Progress Tracking**: Real-time progress bar and question indicator (e.g. `Question 1/4`).

### 📊 5. Comprehensive Results & Performance Analytics
- **Accuracy Score Breakdown**: Calculates accuracy percentage dynamically alongside total correct/incorrect stats.
- **Motivational Feedback**: Displays personalized performance badges and encouraging messages based on test score.
- **Seamless Replayability**: Single-tap buttons to **Play Again** with current settings or return to **Category Selection**.

### 🏗️ 6. Clean Architecture & Code Quality
- Modular separation into **Models, Services, Providers, Screens, Widgets, and Utils**.
- Zero static analysis warnings (`flutter analyze` clean).
- Fully covered with automated unit and widget tests (`flutter test`).

---

## 🛠️ Tech Stack & Dependencies

| Layer / Component | Technology / Library | Usage Description |
| :--- | :--- | :--- |
| **Framework** | [Flutter SDK (Dart)](https://flutter.dev/) | Cross-platform mobile application development |
| **State Management** | [`provider`](https://pub.dev/packages/provider) | Decoupled reactive state management and state propagation |
| **Networking** | [`http`](https://pub.dev/packages/http) | Asynchronous REST API requests to OpenTDB |
| **Data Decoding** | [`html_unescape`](https://pub.dev/packages/html_unescape) | Sanitization and decoding of HTML special entities in questions |
| **Local Storage** | [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Persistent key-value storage for user configurations |
| **API Source** | [OpenTDB REST API](https://opentdb.com/) | Live trivia questions database |

---

## 📁 Project Structure

```
lib/
├── app/
│   ├── app.dart              # Main MaterialApp entry & theme initialization
│   ├── routes.dart           # Named application routes configuration
│   └── theme.dart            # Modern visual theme palette & typography specs
├── models/
│   ├── category.dart         # Category domain entity
│   ├── category_model.dart   # JSON parsing model for OpenTDB categories
│   ├── question.dart         # Question domain entity with answer shuffle logic
│   ├── question_model.dart   # JSON parsing model for OpenTDB questions
│   └── quiz_config_model.dart# Quiz configuration setup parameters
├── providers/
│   ├── category_provider.dart# Category state, loading status, & API fetching logic
│   └── quiz_provider.dart    # Active quiz session state, timer, score, & navigation
├── services/
│   └── api_service.dart      # HTTP REST client service handling OpenTDB endpoints
├── utils/
│   ├── app_colors.dart       # App color palette & contrast definitions
│   └── html_utils.dart       # HTML entity decoding utility functions
├── widgets/
│   ├── answer_button.dart    # Interactive quiz answer card with state animations
│   ├── category_card.dart    # Responsive grid card item for quiz categories
│   ├── loading_skeleton.dart # Skeleton loading indicators for async operations
│   └── retry_banner.dart     # User-friendly network retry banner
└── screens/
    ├── welcome_screen.dart   # Landing screen with student name branding
    ├── category_screen.dart  # Grid view category selection screen
    ├── quiz_config_screen.dart # Custom quiz settings screen
    ├── quiz_screen.dart      # Interactive live quiz engine screen
    └── result_screen.dart    # Final score breakdown & performance analytics
```

---

## 🚀 Getting Started & Installation

### Prerequisites
- **Flutter SDK**: `>=3.0.0`
- **Dart SDK**: `>=3.0.0`
- **IDE**: Android Studio / VS Code with Flutter extension
- **Target Device**: Android Phone or Android Emulator

### Execution Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/israt610/Flutter_Quiz_App.git
   cd Flutter_Quiz_App
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Code Quality Verification

This codebase maintains high software quality standards verified by static analysis and test suites:

- **Run Static Analysis**:
  ```bash
  flutter analyze
  ```
  *(Result: 0 issues found)*

- **Run Automated Test Suite**:
  ```bash
  flutter test
  ```
  *(Result: All unit & widget tests passing)*

---

## 👩‍💻 Author & Exam Details

- **Student Name**: Israt Jahan Tamanna
- **Course**: CSE App Development Lab Exam
- **App Name**: Quizzical
- **GitHub Repository**: [israt610/Flutter_Quiz_App](https://github.com/israt610/Flutter_Quiz_App)
