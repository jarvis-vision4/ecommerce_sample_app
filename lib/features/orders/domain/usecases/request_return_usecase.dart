// Orders Domain - Request Return Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class RequestReturnUseCase extends UseCase<ReturnRequest, RequestReturnParams> {
  final OrdersRepository repository;

  const RequestReturnUseCase(this.repository);

  @override
  Future<DomainResult<ReturnRequest>> call(RequestReturnParams params) {
    return repository.requestReturn(params.id, params.request);
  }
}

class RequestReturnParams {
  final String id;
  final CreateReturnRequest request;
  const RequestReturnParams({required this.id, required this.request});
}