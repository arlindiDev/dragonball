import '../error/failures.dart';
import '../result/result.dart';

abstract class UseCase<T, Params> {
  Future<Result<Failure, T>> call(Params params);
}

class NoParams {}

