/// Excepciones de red personalizadas
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends NetworkException {
  NoInternetException() : super('No hay conexión a internet');
}

class TimeoutException extends NetworkException {
  TimeoutException() : super('Tiempo de espera agotado');
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException() : super('No autorizado', statusCode: 401);
}

class NotFoundException extends NetworkException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

class ServerException extends NetworkException {
  ServerException(String message) : super(message, statusCode: 500);
}
