import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // ================= NOTIFICATIONS =================
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  void initNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    notifications.initialize(settings);
  }

  Future<void> showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Timer',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notifications.show(
      0,
      'Session Complete',
      'Time for a break!',
      details,
    );
  }

  // ================= TIMER =================
  Timer? timer;

  int totalSeconds = 25 * 60;
  int currentSeconds = 25 * 60;
  bool isRunning = false;

  String currentMode = "Focus";
  int completedSessions = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (currentSeconds > 0) {
        setState(() {
          currentSeconds--;
        });
      } else {
        t.cancel();

        setState(() {
          isRunning = false;
          if (currentMode == "Focus") {
            completedSessions++;
          }
        });

        showNotification();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      currentSeconds = totalSeconds;
      isRunning = false;
    });
  }

  void changeMode(String mode) {
    timer?.cancel();

    setState(() {
      currentMode = mode;
      isRunning = false;

      if (mode == "Focus") {
        totalSeconds = 25 * 60;
      } else if (mode == "Short Break") {
        totalSeconds = 5 * 60;
      } else {
        totalSeconds = 15 * 60;
      }

      currentSeconds = totalSeconds;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentSeconds / totalSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro Timer"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$currentMode Mode",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Completed Sessions: $completedSessions",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.pink),
                    ),
                  ),
                  Text(
                    formatTime(currentSeconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: startTimer,
                    child: const Text("Start"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: pauseTimer,
                    child: const Text("Pause"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: resetTimer,
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}