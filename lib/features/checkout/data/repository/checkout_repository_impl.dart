// Checkout Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:flutter_ecommerce/features/checkout/domain/repository/checkout_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.validateCheckout(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Order>> placeOrder(CreateOrderRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.placeOrder(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<PaymentIntent>> createPaymentIntent(CreatePaymentIntentRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.createPaymentIntent(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<PaymentConfirmation>> confirmPayment(ConfirmPaymentRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.confirmPayment(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}