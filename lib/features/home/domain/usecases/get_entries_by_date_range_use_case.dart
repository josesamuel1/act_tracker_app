import 'package:act_tracker/features/home/domain/domain.dart';

class GetEntriesByDateRangeUseCase {
  final ActivityRepository repository;

  GetEntriesByDateRangeUseCase(this.repository);

  Future<List<ActivityEntryEntity>> call({
    required int userId,
    required DateTime start,
    required DateTime end,
  }) {
    final result = repository.getEntriesByDateRange(userId: userId, start: start, end: end);

    return result;
  }
}
