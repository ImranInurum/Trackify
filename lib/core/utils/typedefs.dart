import 'package:fpdart/fpdart.dart';
import '../errors/exceptions.dart';

typedef ResultFuture<T> = Future<Either<AppException, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;
