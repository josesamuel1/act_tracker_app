import 'package:act_tracker/core/core.dart';
import 'package:act_tracker/features/home/domain/entities/activity_entry.entity.dart';
import 'package:act_tracker/features/home/presentation/cubit/home_page_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _CalendarWidget extends StatefulWidget {
  const _CalendarWidget();

  @override
  State<_CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<_CalendarWidget> {
  late final CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();

    // Load the entries for the current month when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageCubit>().loadEntriesForMonth(month: DateTime.now());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Return the focal month from the visible dates of the calendar.
  /// Uses the middle date to avoid ambiguity on the borders.
  DateTime _focalMonth(List<DateTime> visibleDates) {
    return visibleDates[visibleDates.length ~/ 2];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
      listenWhen: (prev, curr) {
        return prev.selectedDate != curr.selectedDate;
      },
      listener: (context, state) {
        // Syncs the selectedDate from the cubit with the calendar controller
        _controller.selectedDate = state.selectedDate;
      },
      buildWhen: (prev, curr) {
        return prev.allEntries != curr.allEntries || prev.selectedDate != curr.selectedDate;
      },
      builder: (context, state) {
        final cubit = context.read<HomePageCubit>();
        final today = DateTime.now();

        return Container(
          padding: const EdgeInsets.all(4.0),
          color: Colors.blue.shade100,
          height: 400.0,
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: _ActivityDataSource(state.allEntries),
            onViewChanged: (details) {
              // Calls when the month is changed: fetches the entries for the new month
              final month = _focalMonth(details.visibleDates);
              cubit.loadEntriesForMonth(month: month);
            },
            onTap: (details) {
              if (details.date != null) {
                // Select the date and fetch the entries for the selected date
                cubit.selectDate(date: details.date!);
              }
            },
            controller: _controller,
            minDate: DateTime(2000),
            maxDate: today,
            showNavigationArrow: true,
            showDatePickerButton: true,
            showTodayButton: true,
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            ),
          ),
        );
      },
    );
  }
}

class _EntriesListWidget extends StatelessWidget {
  const _EntriesListWidget();

  // TODO: Arrumar funcionalidade pra essa função
  // String _formatTime(DateTime time) {
  //   return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  // }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    final isSameDay = date.day == now.day && date.month == now.month && date.year == now.year;

    if (isSameDay) {
      return 'Today';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      buildWhen: (prev, curr) {
        return prev.selectedEntries != curr.selectedEntries ||
            prev.status != curr.status ||
            prev.selectedDate != curr.selectedDate;
      },
      builder: (context, state) {
        final cubit = context.read<HomePageCubit>();
        final date = state.selectedDate;
        final dateLabel = _formatDate(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                'Activities in $dateLabel',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (state.isLoading)
              const Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator())
            else if (state.selectedEntries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 40.0, color: Colors.grey),
                      SizedBox(height: 8.0),
                      Text('None activity in this day', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              Container(
                color: Colors.green.shade50,
                child: Column(
                  children: state.selectedEntries.map((entry) {
                    return _EntryTile(
                      entry: entry,
                      onDelete: () => cubit.deleteEntry(entryId: entry.id),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  final ActivityEntryEntity entry;
  final VoidCallback onDelete;

  const _EntryTile({required this.entry, required this.onDelete});

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Duration get _duration => entry.endTime.difference(entry.startTime);

  @override
  Widget build(BuildContext context) {
    final durationMinutes = _duration.inMinutes;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blue.shade600),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatTime(entry.startTime)} – ${_formatTime(entry.endTime)}  •  ${durationMinutes}min',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            if (entry.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  entry.description,
                  style: const TextStyle(fontSize: 12.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        isThreeLine: entry.description.isNotEmpty,
        trailing: IconButton(
          onPressed: onDelete,
          tooltip: 'Delete entry',
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}

class _TestButtonsWidget extends StatelessWidget {
  const _TestButtonsWidget();

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      buildWhen: (prev, curr) {
        return prev.status != curr.status || prev.hasEntries != curr.hasEntries;
      },
      builder: (context, state) {
        final cubit = context.read<HomePageCubit>();

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Test Functions',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                'Dia selecionado: ${_formatDate(state.selectedDate)}  •  '
                'Entradas no mês: ${state.allEntries.length}  •  '
                'No dia: ${state.selectedEntries.length}',
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 24.0),
              const _SectionTable('Create'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _TestButton(
                    label: 'Create Study',
                    color: Colors.blue,
                    enabled: !state.isLoading,
                    onPressed: () => cubit.addTestEntry(title: 'Study'),
                  ),
                  _TestButton(
                    label: 'Create Exercise',
                    color: Colors.green,
                    enabled: !state.isLoading,
                    onPressed: () => cubit.addTestEntry(title: 'Exercise'),
                  ),
                  _TestButton(
                    label: 'Create Multiples',
                    color: Colors.purple,
                    enabled: !state.isLoading,
                    onPressed: () => cubit.loadMockData(),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const _SectionTable('Update / Delete'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _TestButton(
                    label: 'Update 1ª',
                    color: Colors.orange,
                    enabled: !state.isLoading && state.hasSelectedEntries,
                    onPressed: () => cubit.updateFirstSelectedEntry(),
                  ),
                  _TestButton(
                    label: 'Delete 1ª',
                    color: Colors.red,
                    enabled: !state.isLoading && state.hasSelectedEntries,
                    onPressed: () => cubit.deleteFirstSelectedEntry(),
                  ),
                  _TestButton(
                    label: 'Delete all',
                    color: Colors.red.shade900,
                    enabled: !state.isLoading && state.hasSelectedEntries,
                    onPressed: () => cubit.deleteAllEntries(),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const _SectionTable('Utilities'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _TestButton(
                    label: 'Carregar Mock',
                    color: Colors.teal,
                    enabled: !state.isLoading,
                    onPressed: () => cubit.loadMockData(),
                  ),
                  _TestButton(
                    label: 'Simular Loading',
                    color: Colors.grey,
                    enabled: !state.isLoading,
                    onPressed: () => cubit.simulateLoading(),
                  ),
                  _TestButton(
                    label: 'Simular Erro',
                    color: Colors.brown,
                    enabled: true,
                    onPressed: () => cubit.simulateError(),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              _TestButton(
                label: 'Resetar Estado',
                color: Colors.black,
                enabled: !state.isLoading,
                onPressed: () => cubit.resetState(),
                fullWidth: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTable extends StatelessWidget {
  final String text;
  const _SectionTable(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;
  final bool fullWidth;

  const _TestButton({
    required this.label,
    required this.color,
    required this.enabled,
    required this.onPressed,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        disabledForegroundColor: Colors.white54,
        disabledBackgroundColor: color.withValues(alpha: 0.3),
      ),
      child: Text(label),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppLayoutContainer(
        child: BlocListener<HomePageCubit, HomePageState>(
          listenWhen: (prev, curr) {
            return prev.status != curr.status;
          },
          listener: (context, state) {
            if (state.isError) {
              debugPrint('${CoreStrings.error}: ${state.errorMessage}');
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Unknown error'),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            if (state.isSuccess) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Operation successful'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: const [
                _CalendarWidget(),
                SizedBox(height: 8.0),
                _EntriesListWidget(),
                SizedBox(height: 16.0),
                _TestButtonsWidget(),
                SizedBox(height: 90.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityDataSource extends CalendarDataSource {
  _ActivityDataSource(List<ActivityEntryEntity> source) {
    appointments = source;
  }

  ActivityEntryEntity _get(int index) => appointments![index] as ActivityEntryEntity;

  @override
  DateTime getStartTime(int index) => _get(index).startTime;

  @override
  DateTime getEndTime(int index) => _get(index).endTime;

  @override
  String getSubject(int index) => _get(index).title;

  @override
  Color getColor(int index) => Colors.blue;

  @override
  bool isAllDay(int index) => false;
}

// TODO: Terminar de testar a página e refazer botões da lista de activities
