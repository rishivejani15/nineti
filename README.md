# User Detail & Post Manager App

## Project Overview

This Flutter application allows users to view a list of users, search by name, and see details for each user, including their posts and todos. Users can create new posts which are cached locally for offline availability. The app uses the **BLoC pattern** for state management to ensure clean architecture and separation of concerns.

Key features include:  
- User list with search and infinite scroll loading  
- Detailed user view with posts and todos  
- Add new posts locally (offline caching)  
- Pull to refresh functionality  
- Dark mode toggle (light/dark themes)

---

## Architecture Explanation

The app is structured using the **BLoC (Business Logic Component)** pattern which separates UI from business logic. This promotes testability and scalability.

### Core components:

- **Models**  
  Define data structures (e.g., `User`, `Post`) to represent app entities.

- **Repositories**  
  Abstract data sources (network API, local cache) and provide data to BLoCs.

- **BLoCs**  
  Handle events and emit states:
  - `UserListBloc`: manages fetching, searching, and paginating the user list.
  - `UserDetailBloc`: manages fetching user posts and todos and adding new local posts.

- **UI (Screens and Widgets)**  
  Present the app views and respond to BLoC state changes:
  - `UserListScreen` with search bar and infinite scroll.
  - `UserDetailScreen` to show posts and todos.
  - `CreatePostScreen` to add new posts.

### Offline Caching

Previously, Hive was used for offline caching but has since been removed. You can integrate any preferred local storage (e.g., SQLite, Shared Preferences) for caching posts locally.

### Theming

A toggle button in the app bar allows switching between Light and Dark themes globally.

---

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.x or higher recommended)  
- Dart SDK  
- Android Studio / VS Code or other IDE with Flutter support  
- An emulator or physical device for testing  

### Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
