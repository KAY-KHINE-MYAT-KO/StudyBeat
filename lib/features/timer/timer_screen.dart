import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/providers/study_session_provider.dart';

/// Efficient timer state management using ChangeNotifier
/// Instead of calling setState() every second, we only notify listeners
class _TimerValue extends ChangeNotifier {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;

  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;
  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;

  void incrementSecond() {
    _seconds++;
    _totalSeconds++;
    if (_seconds == 60) {
      _seconds = 0;
      _minutes++;
      if (_minutes == 60) {
        _minutes = 0;
        _hours++;
      }
    }
    notifyListeners();
  }

  void setRunning(bool running) {
    _isRunning = running;
    notifyListeners();
  }

  void reset() {
    _hours = 0;
    _minutes = 0;
    _seconds = 0;
    _totalSeconds = 0;
    _isRunning = false;
    notifyListeners();
  }
}

class TimerScreen extends StatefulWidget {
  final List<String> selectedTopics;

  const TimerScreen({super.key, required this.selectedTopics});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late _TimerValue _timerValue;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timerValue = _TimerValue();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerValue.dispose();
    super.dispose();
  }

  void _startPauseTimer() {
    if (_timerValue.isRunning) {
      // Pause
      _timer?.cancel();
      _timerValue.setRunning(false);
    } else {
      // Start
      _timerValue.setRunning(true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _timerValue.incrementSecond();
      });
    }
  }

  void _resetTimer() {
    // Save session before resetting if there was any time
    if (_timerValue.totalSeconds > 0) {
      _saveSession();
    }
    _timer?.cancel();
    _timerValue.reset();
  }

  Future<void> _saveSession() async {
    if (_timerValue.totalSeconds <= 0) return;
    await context.read<StudySessionProvider>().saveSession(
      topics: widget.selectedTopics,
      durationInSeconds: _timerValue.totalSeconds,
    );
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const AppBarWidget(title: 'StudyBeat'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Study Timer', style: AppTextStyles.h1),
              const SizedBox(height: 8),

              // Selected Topics
              if (widget.selectedTopics.isNotEmpty) ...[
                Text('Studying:', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.selectedTopics.map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Text(
                        topic,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 32),

              // Timer Display Cards (listens to _timerValue changes)
              ListenableBuilder(
                listenable: _timerValue,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimeCard(
                        value: _formatTime(_timerValue.hours),
                        label: 'Hours',
                      ),
                      const SizedBox(width: 16),
                      _TimeCard(
                        value: _formatTime(_timerValue.minutes),
                        label: 'Minutes',
                      ),
                      const SizedBox(width: 16),
                      _TimeCard(
                        value: _formatTime(_timerValue.seconds),
                        label: 'Seconds',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 48),

              // Control Buttons
              ListenableBuilder(
                listenable: _timerValue,
                builder: (context, child) {
                  return PrimaryButton(
                    text: _timerValue.isRunning ? 'Pause' : 'Start',
                    onPressed: _startPauseTimer,
                  );
                },
              ),

              const SizedBox(height: 12),

              SecondaryButton(text: 'Save & Reset', onPressed: _resetTimer),

              const SizedBox(height: 24),

              // Session Info
              ListenableBuilder(
                listenable: _timerValue,
                builder: (context, child) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session Info', style: AppTextStyles.h3),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Time',
                                style: AppTextStyles.bodySmall,
                              ),
                              Text(
                                '${_formatTime(_timerValue.hours)}:${_formatTime(_timerValue.minutes)}:${_formatTime(_timerValue.seconds)}',
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Topics Covered',
                                style: AppTextStyles.bodySmall,
                              ),
                              Text(
                                '${widget.selectedTopics.length}',
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String value;
  final String label;

  const _TimeCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Text(
                value,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
