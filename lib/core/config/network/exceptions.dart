import 'package:equatable/equatable.dart';

/// [AppException] is the base class for all custom exceptions in the application.
/// It implements [Exception] and uses [Equatable] for value equality.
class AppException extends Equatable implements Exception {
  final String message;
  final String prefix;
  final int? statusCode;

  const AppException({
    required this.message,
    required this.prefix,
    this.statusCode,
  });

  @override
  String toString() {
    final status = statusCode != null ? ' [$statusCode]' : '';
    return '$prefix: $message$status';
  }

  @override
  List<Object?> get props => [message, prefix, statusCode];
}

/// Thrown when there's an error during communication with the server.
class FetchDataException extends AppException {
  const FetchDataException([String message = 'Error occurred during communication'])
      : super(message: message, prefix: 'Fetch Data Error');
}

/// Thrown when the server returns a 400 Bad Request status code.
class BadRequestException extends AppException {
  const BadRequestException([String message = 'Invalid request', int statusCode = 400])
      : super(message: message, prefix: 'Bad Request', statusCode: statusCode);
}

/// Thrown when the server returns a 401 Unauthorised status code.
class UnauthorisedException extends AppException {
  const UnauthorisedException([String message = 'Unauthorised request', int statusCode = 401])
      : super(message: message, prefix: 'Unauthorised', statusCode: statusCode);
}

/// Thrown when the server returns a 403 Forbidden status code.
class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Forbidden request', int statusCode = 403])
      : super(message: message, prefix: 'Forbidden', statusCode: statusCode);
}

/// Thrown when the server returns a 404 Not Found status code.
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found', int statusCode = 404])
      : super(message: message, prefix: 'Not Found', statusCode: statusCode);
}

/// Thrown when the server returns a 500 Internal Server Error status code.
class InternalServerException extends AppException {
  const InternalServerException([String message = 'Internal server error', int statusCode = 500])
      : super(message: message, prefix: 'Internal Server Error', statusCode: statusCode);
}

/// Thrown when the user input is invalid.
class InvalidInputException extends AppException {
  const InvalidInputException([String message = 'Invalid input'])
      : super(message: message, prefix: 'Invalid Input');
}

/// Thrown when there's no internet connection.
class NoInternetException extends AppException {
  const NoInternetException([String message = 'No internet connection'])
      : super(message: message, prefix: 'No Internet');
}

/// Thrown when there's an error with the local cache/storage.
class CacheException extends AppException {
  const CacheException([String message = 'Cache error'])
      : super(message: message, prefix: 'Cache Error');
}

/// Thrown when a request times out.
class RequestTimeoutException extends AppException {
  const RequestTimeoutException([String message = 'Request timed out'])
      : super(message: message, prefix: 'Timeout Error');
}
