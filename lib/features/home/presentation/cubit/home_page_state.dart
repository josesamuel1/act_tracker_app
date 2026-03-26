part of 'home_page_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomePageState extends Equatable {
  final HomeStatus status;
  final List<ActivityEntryEntity> allEntries;
  final List<ActivityEntryEntity> selectedEntries;
  final DateTime selectedDate;
  final String? errorMessage;

  const HomePageState({
    required this.status,
    required this.allEntries,
    required this.selectedEntries,
    required this.selectedDate,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [status, allEntries, selectedEntries, selectedDate, errorMessage];

  factory HomePageState.initial() => HomePageState(
    status: HomeStatus.initial,
    allEntries: const [],
    selectedEntries: const [],
    selectedDate: DateTime.now(),
    errorMessage: null,
  );

  // Getters for easy access to the status properties
  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isError => status == HomeStatus.error;
  bool get hasEntries => allEntries.isNotEmpty;
  bool get hasSelectedEntries => selectedEntries.isNotEmpty;

  HomePageState copyWith({
    HomeStatus? status,
    List<ActivityEntryEntity>? allEntries,
    List<ActivityEntryEntity>? selectedEntries,
    DateTime? selectedDate,
    String? errorMessage,
    // Flag to clear the error message
    bool clearError = false,
  }) {
    return HomePageState(
      status: status ?? this.status,
      allEntries: allEntries ?? this.allEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
