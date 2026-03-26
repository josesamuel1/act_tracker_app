import 'package:act_tracker/features/home/domain/domain.dart';

class CreateEntryUseCase {
  final ActivityRepository repository;

  CreateEntryUseCase(this.repository);

  Future<void> call({required ActivityEntryEntity entry}) async {
    final result = await repository.insertEntry(entry: entry);

    return result;
  }
}
