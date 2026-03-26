import 'package:act_tracker/features/home/domain/domain.dart';

class UpdateEntryUseCase {
  final ActivityRepository repository;

  UpdateEntryUseCase(this.repository);

  Future<void> call({required ActivityEntryEntity entry}) async {
    final result = await repository.updateEntry(entry: entry);

    return result;
  }
}
