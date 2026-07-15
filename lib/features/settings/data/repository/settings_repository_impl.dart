// Settings Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:flutter_ecommerce/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:flutter_ecommerce/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<AppSettings>> getAppSettings() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getAppSettings();
      if (result.isSuccess) {
        await localDataSource.cacheSettings(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedSettings();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<ShippingOption>>> getShippingOptions() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getShippingOptions();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<AppCurrency>>> getSupportedCurrencies() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getSupportedCurrencies();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<AvailablePaymentMethod>>> getAvailablePaymentMethods() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getAvailablePaymentMethods();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> updateSettings(AppSettings settings) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.updateSettings(settings);
      if (result.isSuccess) {
        await localDataSource.cacheSettings(settings);
      }
      return result;
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}