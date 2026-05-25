import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'notes_screen.dart';
import 'assignments_screen.dart';
import 'pomodoro_screen.dart';
import 'timetable_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/page_transitions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notesCount = 0;
  int sessionsCount = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notesCount = prefs.getStringList('notes')?.length ?? 0;
      sessionsCount = prefs.getInt('sessions') ?? 0;
    });
  }

  Future<void> openPage(Widget page) async {
    await Navigator.push(
      context,
      PageTransitions.slide(page),
    );
    await loadStats(); // refresh after return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome 👋",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Organize your study life easily.",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            // DASHBOARD
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("Notes"),
                      Text("$notesCount",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Sessions"),
                      Text("$sessionsCount",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  FeatureCard(
                    title: "Timetable",
                    icon: Icons.schedule,
                    onTap: () => openPage(const TimetableScreen()),
                  ),
                  FeatureCard(
                    title: "Assignments",
                    icon: Icons.assignment,
                    onTap: () => openPage(const AssignmentsScreen()),
                  ),
                  FeatureCard(
                    title: "Pomodoro",
                    icon: Icons.timer,
                    onTap: () => openPage(const PomodoroScreen()),
                  ),
                  FeatureCard(
                    title: "Notes",
                    icon: Icons.note,
                    onTap: () => openPage(const NotesScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}