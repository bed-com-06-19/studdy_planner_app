import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String selectedDay = "Monday";

  late Map<String, List<String>> timetable;

  @override
  void initState() {
    super.initState();

    timetable = {
      "Monday": [],
      "Tuesday": [],
      "Wednesday": [],
      "Thursday": [],
      "Friday": [],
      "Saturday": [],
      "Sunday": [],
    };

    loadTimetable();
  }

  Future<void> loadTimetable() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      for (String day in timetable.keys) {
        timetable[day] = prefs.getStringList(day) ?? [];
      }
    });
  }

  Future<void> saveTimetable() async {
    final prefs = await SharedPreferences.getInstance();

    for (String day in timetable.keys) {
      await prefs.setStringList(day, timetable[day] ?? []);
    }
  }

  Future<void> addClass() async {
    if (subjectController.text.isEmpty || timeController.text.isEmpty) return;

    String entry = "${subjectController.text} - ${timeController.text}";

    setState(() {
      timetable[selectedDay] ??= [];
      timetable[selectedDay]!.add(entry);
    });

    await saveTimetable();

    subjectController.clear();
    timeController.clear();
  }

  Future<void> deleteClass(String day, int index) async {
    setState(() {
      timetable[day]?.removeAt(index);
    });

    await saveTimetable();
  }

  @override
  Widget build(BuildContext context) {
    final dayList = timetable.keys.toList();
    final currentList = timetable[selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly Timetable"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DAYS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dayList.map((day) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(day),
                      selected: selectedDay == day,
                      onSelected: (_) {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),

            // INPUT SUBJECT
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
                filled: true,
                fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // INPUT TIME
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: "Time (e.g 08:00 - 09:00)",
                filled: true,
                fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addClass,
              child: Text("Add to $selectedDay"),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: currentList.isEmpty
                  ? Center(
                      child: Text("No classes on $selectedDay"),
                    )
                  : ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final item = currentList[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.schedule),
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteClass(selectedDay, index),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}