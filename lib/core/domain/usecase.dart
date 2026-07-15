// Core Domain - Base UseCase Class
import 'package:flutter_ecommerce/core/domain/result.dart';

abstract class UseCase<Type, Params> {
  const UseCase();

  Future<DomainResult<Type>> call(Params params);

  Future<DomainResult<Type>> execute(Params params) => call(params);
}

abstract class NoParamsUseCase<Type> {
  const NoParamsUseCase();


  Future<DomainResult<Type>> call();

  Future<DomainResult<Type>> execute() => call();
}

class NoParams {
  const NoParams();
}