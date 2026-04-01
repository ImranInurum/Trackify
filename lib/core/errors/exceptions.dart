// import 'package:equatable/equatable.dart';
//
// class AppException extends Equatable implements Exception {
//   final String? message;
//   final dynamic prefix;
//
//   const AppException([this.message, this.prefix]);
//
//   @override
//   String toString() {
//     return '$message$prefix';
//   }
//
//   @override
//   List<Object?> get props => [message, prefix];
// }
//
// class FetchDataException extends AppException {
//   const FetchDataException([String? message])
//       : super(message, 'Error During Communication');
// }
//
// class InternalServerException extends AppException {
//   const InternalServerException([String? message, dynamic status])
//       : super(
//     message,
//     'Internal server error [500]',
//   );
// }
//
// class BadRequestException extends AppException {
//   const BadRequestException([String? message])
//       : super(message, 'Invalid request [400]');
// }
//
// class UnauthorisedException extends AppException {
//   const UnauthorisedException([String? message])
//       : super(message, 'Unauthorised request [404]');
// }
//
// class InvalidInputException extends AppException {
//   const InvalidInputException([String? message])
//       : super(message, 'Invalid Input');
// }
//
// class NoInternetException extends AppException {
//   const NoInternetException([String? message])
//       : super(message, 'Communication issue');
// }
//
// class APIException extends Equatable implements Exception {
//   const APIException({required this.message, required this.statusCode});
//   final String message;
//   final dynamic statusCode;
//
//   @override
//   List<Object?> get props => [message, statusCode];
// }
//
// class ServerException extends Equatable implements Exception {
//   const ServerException({required this.message, required this.statusCode});
//   final String message;
//   final dynamic statusCode;
//
//   @override
//   List<Object?> get props => [message, statusCode];
// }
//
// class CacheException extends Equatable implements Exception {
//   const CacheException({required this.message});
//   final String message;
//
//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final String prefix;

  const AppException({required this.message, required this.prefix, this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return '$message [$statusCode]';
    }
    return message;
  }

  @override
  List<Object?> get props => [message, statusCode, prefix];
}

class FetchDataException extends AppException {
  const FetchDataException([
    String message = 'Error occurred while communicating with server',
  ]) : super(message: message, prefix: 'Fetch Data Error');
}

class InternalServerException extends AppException {
  const InternalServerException([
    String message = 'Internal server error',
    int statusCode = 500,
  ]) : super(message: message, prefix: 'Internal Server Error', statusCode: statusCode);
}

class BadRequestException extends AppException {
  const BadRequestException([String message = 'Invalid request', int statusCode = 400])
    : super(message: message, prefix: 'Bad Request', statusCode: statusCode);
}

class UnauthorisedException extends AppException {
  const UnauthorisedException([
    String message = 'Unauthorised request',
    int statusCode = 401,
  ]) : super(message: message, prefix: 'Unauthorised', statusCode: statusCode);
}

class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Forbidden request', int statusCode = 403])
    : super(message: message, prefix: 'Forbidden', statusCode: statusCode);
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found', int statusCode = 404])
    : super(message: message, prefix: 'Not Found', statusCode: statusCode);
}

class InvalidInputException extends AppException {
  const InvalidInputException([String message = 'Invalid input'])
    : super(message: message, prefix: 'Invalid Input');
}

class NoInternetException extends AppException {
  const NoInternetException([String message = 'No internet connection'])
    : super(message: message, prefix: 'No Internet');
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error'])
    : super(message: message, prefix: 'Cache Error');
}
