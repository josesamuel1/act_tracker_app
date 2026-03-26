import 'package:act_tracker/features/home/domain/domain.dart';

class DeleteEntryUseCase {
  final ActivityRepository repository;

  DeleteEntryUseCase(this.repository);

  Future<void> call({required int entryId}) async {
    final result = await repository.deleteEntry(entryId: entryId);

    return result;
  }
}
