# Project Technical Stack: AI Tracker

This document provides a comprehensive list of Flutter Widgets and Dart features used in the `ai_tracker` project.

## Flutter Widgets Used

### Foundation & Layout
- `MaterialApp`: The root of the application, configuring themes and home page.
- `Scaffold`: Basic visual layout structure for pages, providing `appBar`, `body`, `floatingActionButton`, and `bottomNavigationBar`.
- `AppBar`: Top app bar for titles and actions.
- `NavigationBar`: Modern bottom navigation bar for switching between pages.
- `NavigationDestination`: Individual items within the `NavigationBar`.
- `Column`: Vertical layout for stacking widgets.
- `Row`: Horizontal layout for placing widgets side-by-side.
- `Padding`: Adds whitespace around child widgets.
- `Expanded`: Allows a child of a `Column` or `Row` to fill available space.
- `SizedBox`: Used for fixed-size boxes or simple spacing.
- `Center`: Centers its child within itself.
- `SingleChildScrollView`: Enables scrolling for a single child widget, typically used for forms.
- `Wrap`: Lays out children in multiple horizontal or vertical runs (used for `ChoiceChip` list).

### Lists & Scrolling
- `ListView.builder`: Efficiently creates a scrollable list of widgets on demand.
- `ListTile`: A single fixed-height row that typically contains text and icons.
- `Dismissible`: A widget that can be dismissed by swiping in the indicated direction.

### Forms & Input
- `Form`: Container for grouping and validating multiple form fields.
- `TextFormField`: A `TextField` integrated with `Form` for validation and state management.
- `TextEditingController`: Controller for reading and modifying text in input fields.
- `GlobalKey<FormState>`: Used to identify and validate the form.
- `InputDecoration`: Customizes the appearance of input fields (labels, borders, icons).
- `Switch`: A material design "on/off" switch.
- `ChoiceChip`: A material design chip that allows a single selection from a set.
- `ElevatedButton`: A button with a shadow and material elevation.
- `TextButton`: A simple flat button used in dialogs.

### Feedback & Status
- `CircularProgressIndicator`: A progress indicator that spins to indicate loading.
- `SnackBar`: A brief message at the bottom of the screen for feedback.
- `ScaffoldMessenger`: Used to show `SnackBar`s.
- `AlertDialog`: A popup dialog for confirmations (e.g., delete confirmation).
- `Chip`: A compact element that represents an attribute or status.
- `CircleAvatar`: A circular area for icons or text (used inside status chips).

### State Management & Navigation
- `StatelessWidget`: For widgets that don't maintain internal state.
- `StatefulWidget`: For widgets that maintain state and can rebuild.
- `ListenableBuilder`: Modern widget for rebuilding parts of the UI when a `Listenable` (like `AccountNotifier`) changes.
- `Navigator`: Manages a stack of routes for navigating between pages.
- `MaterialPageRoute`: A modal route that replaces the entire screen with a platform-adaptive transition.

### Icons & Styling
- `Icon`: Displays material design icons.
- `Icons`: Static constants for material design icons.
- `Text`: Displays a string of text with a single style.
- `TextStyle`: Customizes the appearance of text (font size, weight, color, style).
- `ThemeData`: Defines the overall theme of the application.
- `ColorScheme`: A set of colors based on Material 3.

## Flutter Features Used

- **Material 3 Design**: Enabled via `ThemeData` and used throughout the UI.
- **Form Validation**: Using `GlobalKey<FormState>` and `validator` functions in `TextFormField`.
- **Date Picker**: Using `showDatePicker` for selecting dates.
- **Asynchronous UI**: Handling `Future` results and showing loading states during database operations.
- **Swipe-to-Action**: Implementing status updates via `Dismissible`.
- **Theme Configuration**: Setting up a dark theme with a seed color.

## Dart Features Used

- **Null Safety**: Used throughout the project (e.g., `?` for nullable types, `required` keyword).
- **Asynchronous Programming**: Extensive use of `async`, `await`, and `Future` for database and UI operations.
- **Constructor Features**: Using `super.key`, `required`, and initializing parameters.
- **Enhanced Enums**: Used for `AccountStatus` to associate values with enum members.
- **Factory Constructors**: Used in `AccountModel` for `fromJson` and `fromEntity`.
- **Spread Operator (`...`)**: Used in lists and maps.
- **Collection if**: Used in `toJson` to conditionally include fields.
- **Type Casting**: Using `as` for JSON parsing.
- **Regular Expressions**: Used for email validation.
- **Inheritance**: Models extending entities, and custom widgets extending `StatelessWidget` or `StatefulWidget`.

## External Libraries (Dependencies)

- `sqflite`: For local SQLite database storage.
- `path`: For managing file system paths.
- `cupertino_icons`: For iOS-style icons (standard in Flutter projects).
