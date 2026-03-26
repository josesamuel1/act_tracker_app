import 'package:act_tracker/features/home/domain/domain.dart';

class GetEntriesByDateUseCase {
  final ActivityRepository repository;

  GetEntriesByDateUseCase(this.repository);

  Future<List<ActivityEntryEntity>> call({required int userId, required DateTime date}) async {
    final result = await repository.getEntriesByDate(userId: userId, date: date);

    return result;
  }
}
