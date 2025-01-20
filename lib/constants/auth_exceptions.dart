abstract class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class BadRequestException extends AuthException {
  BadRequestException(super.message);
}

class UnauthorizedException extends AuthException {
  UnauthorizedException(super.message);
}

class NotFoundException extends AuthException {
  NotFoundException(super.message);
}

class ServerException extends AuthException {
  ServerException(super.message);
}

class NetworkException extends AuthException {
  NetworkException(super.message);
}

class LogInException extends AuthException {
  LogInException(super.message);
}

class SignUpException extends AuthException {
  SignUpException(super.message);
}
