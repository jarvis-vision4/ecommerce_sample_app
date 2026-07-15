// Payment Methods Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/payment_methods/data/datasources/payment_methods_local_datasource.dart';
import 'package:flutter_ecommerce/features/payment_methods/data/datasources/payment_methods_remote_datasource.dart';
import 'package:flutter_ecommerce/features/payment_methods/domain/repository/payment_methods_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsRemoteDataSource remoteDataSource;
  final PaymentMethodsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PaymentMethodsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<List<PaymentMethod>>> getPaymentMethods() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getPaymentMethods();
      if (result.isSuccess) {
        await localDataSource.cachePaymentMethods(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedPaymentMethods();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<PaymentMethod>> addPaymentMethod(AddPaymentMethodRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.addPaymentMethod(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> removePaymentMethod(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.removePaymentMethod(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<PaymentMethod>> setDefaultPaymentMethod(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.setDefaultPaymentMethod(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}