import 'package:act_tracker/core/widgets/widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime minDate = DateTime(2000);
  final DateTime maxDate = DateTime.now();

  List<ActivityEntry> _selectedEntries = [];
  DateTime? _selectedDate;

  late final List<ActivityEntry> _entries = _mockEntries();

  List<ActivityEntry> _mockEntries() {
    final today = DateTime.now();

    final studyTag = EntryTag(id: '1', name: 'Estudo', color: Colors.blue);
    final workoutTag = EntryTag(id: '2', name: 'Treino', color: Colors.green);

    return [
      ActivityEntry(
        id: 'a1',
        title: 'Estudar Flutter',
        description: 'Revisão sobre gerenciamento de estado',
        startTime: DateTime(today.year, today.month, today.day, 9),
        endTime: DateTime(today.year, today.month, today.day, 11),
        tag: studyTag,
      ),
      ActivityEntry(
        id: 'a2',
        title: 'Treino de corrida',
        description: '5km leve',
        startTime: DateTime(today.year, today.month, today.day, 18),
        endTime: DateTime(today.year, today.month, today.day, 19),
        tag: workoutTag,
      ),
    ];
  }

  void _onCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell ||
        details.targetElement == CalendarElement.appointment) {
      setState(() {
        _selectedDate = details.date;

        if (details.appointments != null && details.appointments!.isNotEmpty) {
          _selectedEntries = details.appointments!.cast<ActivityEntry>();
        } else {
          _selectedEntries = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayoutContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              color: Colors.blue.shade100,
              height: 400.0,
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: ActivityDataSource(_entries),
                onTap: _onCalendarTap,
                allowViewNavigation: false,
                minDate: minDate,
                maxDate: maxDate,
                showNavigationArrow: true,
                showDatePickerButton: true,
                showTodayButton: true,
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.green.shade100,
              child: _selectedEntries.isEmpty
                  ? const Center(child: Text('Nenhuma atividade neste dia.'))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _selectedEntries.map((entry) {
                        return ListTile(
                          leading: CircleAvatar(backgroundColor: entry.tag.color),
                          title: Text(entry.title),
                          subtitle: Text(
                            '${entry.startTime.hour}:${entry.startTime.minute.toString().padLeft(2, '0')} - '
                            '${entry.endTime.hour}:${entry.endTime.minute.toString().padLeft(2, '0')}'
                            '\n${entry.description}',
                          ),
                        );
                      }).toList(),
                    ),
            ),

            SizedBox(height: 90.0),
          ],
        ),
      ),
    );
  }
}

class ActivityDataSource extends CalendarDataSource {
  ActivityDataSource(List<ActivityEntry> source) {
    appointments = source;
  }

  ActivityEntry _get(int index) => appointments![index] as ActivityEntry;

  @override
  DateTime getStartTime(int index) => _get(index).startTime;

  @override
  DateTime getEndTime(int index) => _get(index).endTime;

  @override
  String getSubject(int index) => _get(index).title;

  @override
  Color getColor(int index) => _get(index).tag.color;

  @override
  bool isAllDay(int index) => false;
}

class ActivityEntry {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EntryTag tag;

  ActivityEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.tag,
  });
}

class EntryTag {
  final String id;
  final String name;
  final Color color;

  EntryTag({required this.id, required this.name, required this.color});
}
