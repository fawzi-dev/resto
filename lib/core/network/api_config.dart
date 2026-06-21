// Build-time configuration. Override with --dart-define, e.g.
//   flutter run --dart-define=USE_REMOTE_API=true \
//               --dart-define=API_BASE_URL=http://10.0.2.2:8080
abstract final class ApiConfig {
  static const bool useRemoteApi =
      bool.fromEnvironment('USE_REMOTE_API', defaultValue: false);

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
