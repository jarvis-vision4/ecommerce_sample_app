// Products Domain - Get Products Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetProductsUseCase extends UseCase<PaginatedResponse<Product>, GetProductsParams> {
  final ProductsRepository repository;

  const GetProductsUseCase(this.repository);

  @override
  Future<DomainResult<PaginatedResponse<Product>>> call(GetProductsParams params) {
    return repository.getProducts(
      page: params.page,
      limit: params.limit,
      categoryId: params.categoryId,
      search: params.search,
      sort: params.sort,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      brand: params.brand,
      inStock: params.inStock,
    );
  }
}

class GetProductsParams {
  final int page;
  final int limit;
  final String? categoryId;
  final String? search;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;
  final String? brand;
  final bool? inStock;

  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.search,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.brand,
    this.inStock,
  });
}