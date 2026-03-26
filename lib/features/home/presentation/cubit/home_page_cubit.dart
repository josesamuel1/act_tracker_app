import 'package:act_tracker/features/home/domain/entities/activity_entry.entity.dart';
import 'package:act_tracker/features/home/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final GetEntriesByDateUseCase getEntriesByDateUseCase;
  final GetEntriesByDateRangeUseCase getEntriesByDateRangeUseCase;
  final CreateEntryUseCase createEntryUseCase;
  final UpdateEntryUseCase updateEntryUseCase;
  final DeleteEntryUseCase deleteEntryUseCase;
  final int userId;

  HomePageCubit({
    required this.getEntriesByDateUseCase,
    required this.getEntriesByDateRangeUseCase,
    required this.createEntryUseCase,
    required this.updateEntryUseCase,
    required this.deleteEntryUseCase,
    required this.userId,
  }) : super(HomePageState.initial());

  // Load entries for the current month when the cubit is initialized
  Future<void> loadEntriesForMonth({required DateTime month}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final entries = await getEntriesByDateRangeUseCase(userId: userId, start: start, end: end);

      final selected = state.selectedDate;
      final isSelectedInMonth = selected.year == month.year && selected.month == month.month;

      List<ActivityEntryEntity> selectedEntries = state.selectedEntries;
      if (isSelectedInMonth) {
        selectedEntries = await getEntriesByDateUseCase(userId: userId, date: selected);
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          allEntries: entries,
          selectedEntries: selectedEntries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error loading entries for month: $e.toString()',
        ),
      );
    }
  }

  // Load entries for the selected date when the date is changed
  Future<void> selectDate({required DateTime date}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, selectedDate: date, clearError: true));

      final entries = await getEntriesByDateUseCase(userId: userId, date: date);

      emit(state.copyWith(status: HomeStatus.success, selectedEntries: entries));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error loading entries for date: $e.toString()',
        ),
      );
    }
  }

  // Create a test entry for the selected date
  Future<void> addTestEntry({required String title}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      final day = state.selectedDate;
      final entry = ActivityEntryEntity(
        id: 0,
        userId: userId,
        title: title,
        description: 'This is a test entry.',
        startTime: DateTime(day.year, day.month, day.day, 9, 0),
        endTime: DateTime(day.year, day.month, day.day, 10, 0),
      );

      await createEntryUseCase(entry: entry);
      await _reloadAfterChange();
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error adding test entry: $e.toString()',
        ),
      );
    }
  }

  // Update the first test selected entry
  Future<void> updateFirstSelectedEntry() async {
    try {
      if (state.selectedEntries.isEmpty) return;

      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      final first = state.selectedEntries.first;
      final now = DateTime.now();
      final updated = ActivityEntryEntity(
        id: first.id,
        userId: first.userId,
        title: '${first.title} (Updated)',
        description:
            'Atualizado em ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')} '
            'às ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        startTime: first.startTime,
        endTime: first.endTime.add(const Duration(minutes: 30)),
      );

      await updateEntryUseCase(entry: updated);
      await _reloadAfterChange();
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error updating first selected entry: $e.toString()',
        ),
      );
    }
  }

  // Delete specific test selected entry by ID
  Future<void> deleteEntry({required int entryId}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      await deleteEntryUseCase(entryId: entryId);
      await _reloadAfterChange();
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error deleting test entry: $e.toString()',
        ),
      );
    }
  }

  /// Delete the first selected entry
  Future<void> deleteFirstSelectedEntry() async {
    if (state.selectedEntries.isEmpty) return;

    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    try {
      await deleteEntryUseCase(entryId: state.selectedEntries.first.id);
      await _reloadAfterChange();
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: 'Erro ao deletar entrada: $e'));
    }
  }

  // Delete all test entries for the current month
  Future<void> deleteAllEntries() async {
    try {
      if (state.allEntries.isEmpty) return;

      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      for (final entry in state.allEntries) {
        await deleteEntryUseCase(entryId: entry.id);
      }

      await _reloadAfterChange();
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error updating first selected entry: $e.toString()',
        ),
      );
    }
  }

  // Simulate loading mock data
  Future<void> loadMockData() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, clearError: true));

      final day = state.selectedDate;
      final mockEntries = [
        ActivityEntryEntity(
          id: 0,
          userId: userId,
          title: 'Mock Entry 1',
          description: 'This is a mock entry n1',
          startTime: DateTime(day.year, day.month, day.day, 8, 0),
          endTime: DateTime(day.year, day.month, day.day, 9, 0),
        ),
        ActivityEntryEntity(
          id: 0,
          userId: userId,
          title: 'Mock Entry 1',
          description: 'This is a mock entry n1',
          startTime: DateTime(day.year, day.month, day.day, 12, 0),
          endTime: DateTime(day.year, day.month, day.day, 13, 0),
        ),
        ActivityEntryEntity(
          id: 0,
          userId: userId,
          title: 'Mock Entry 1',
          description: 'This is a mock entry n1',
          startTime: DateTime(day.year, day.month, day.day, 17, 0),
          endTime: DateTime(day.year, day.month, day.day, 18, 0),
        ),
      ];

      for (final entry in mockEntries) {
        await createEntryUseCase(entry: entry);
      }

      await _reloadAfterChange();
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error loading mock data: $e.toString()',
        ),
      );
    }
  }

  // Simulate loading
  Future<void> simulateLoading() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: HomeStatus.success));
  }

  // Simulate error
  Future<void> simulateError() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: HomeStatus.error, errorMessage: 'Simulating error...'));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: HomeStatus.success));
  }

  // Reset the state to its initial values
  Future<void> resetState() async {
    emit(HomePageState.initial());
  }

  // Reload the entries after a change in the date
  Future<void> _reloadAfterChange() async {
    try {
      final month = state.selectedDate;
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final entries = await getEntriesByDateRangeUseCase(userId: userId, start: start, end: end);
      final selectedEntries = await getEntriesByDateUseCase(
        userId: userId,
        date: state.selectedDate,
      );

      emit(
        state.copyWith(
          status: HomeStatus.success,
          allEntries: entries,
          selectedEntries: selectedEntries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Error reloading after change: $e.toString()',
        ),
      );
    }
  }
}
