/// Configuración de flavors (dev, staging, prod)
enum Flavor {
  dev,
  staging,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;
  final String wsUrl;
  final bool enableLogging;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.enableLogging,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    _instance ??= _dev;
    return _instance!;
  }

  static void setFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        _instance = _dev;
        break;
      case Flavor.staging:
        _instance = _staging;
        break;
      case Flavor.prod:
        _instance = _prod;
        break;
    }
  }

  static final FlavorConfig _dev = FlavorConfig._(
    flavor: Flavor.dev,
    name: 'DEV',
    apiBaseUrl: 'https://dev-api.pizzasreyna.com/api/v1',
    wsUrl: 'wss://dev-api.pizzasreyna.com/ws',
    enableLogging: true,
  );

  static final FlavorConfig _staging = FlavorConfig._(
    flavor: Flavor.staging,
    name: 'STAGING',
    apiBaseUrl: 'https://staging-api.pizzasreyna.com/api/v1',
    wsUrl: 'wss://staging-api.pizzasreyna.com/ws',
    enableLogging: true,
  );

  static final FlavorConfig _prod = FlavorConfig._(
    flavor: Flavor.prod,
    name: 'PROD',
    apiBaseUrl: 'https://localhost:8080/api',
    wsUrl: 'wss://api.pizzasreyna.com/ws',
    enableLogging: false,
  );

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
