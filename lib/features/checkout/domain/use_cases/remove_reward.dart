import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class RemoveReward implements UseCase<String, NoParams> {
  final CheckoutRepository _checkoutRepository;

  RemoveReward({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _checkoutRepository.removeReward();
  }
}
