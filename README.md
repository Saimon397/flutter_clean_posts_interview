# Flutter Clean Posts

Small demo app built with:

- **Flutter** (Material Design, Material 3)
- **BLoC** for state management (`flutter_bloc`)
- **Dio** for HTTP calls
- **GoRouter** for navigation
- **local_auth** for biometric auth (+ PIN fallback)
- **get_it** for dependency injection
- **Infinite scroll** for loading more posts

The app fetches posts from `https://jsonplaceholder.typicode.com/posts`, shows them in a paginated list, allows **remote search**, and protects the post detail with **biometric / PIN (1234) authentication**.

---

## Getting Started

### Install dependencies

```bash
flutter pub get
