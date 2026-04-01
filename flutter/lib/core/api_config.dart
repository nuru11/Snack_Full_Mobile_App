/// Base URL for the Node API.
///
/// - Windows / iOS simulator / Web: default `http://127.0.0.1:3000`
/// - Android emulator: run with
///   `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000`
/// - Physical device: use your PC LAN IP, e.g.
///   `--dart-define=API_BASE_URL=http://192.168.1.5:3000`
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.7:3000',
  );
}
