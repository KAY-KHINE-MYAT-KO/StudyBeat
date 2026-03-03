import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/providers/study_session_provider.dart';

class TimerScreen extends StatefulWidget {
  final List<String> selectedTopics;

  const TimerScreen({super.key, required this.selectedTopics});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool _isRunning = false;
  int _totalSeconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPauseTimer() {
    if (_isRunning) {
      // Pause
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      // Start
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
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
        });
      });
    }
  }

  void _resetTimer() {
    // Save session before resetting if there was any time
    if (_totalSeconds > 0) {
      _saveSession();
    }
    _timer?.cancel();
    setState(() {
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _totalSeconds = 0;
      _isRunning = false;
    });
  }

  Future<void> _saveSession() async {
    if (_totalSeconds <= 0) return;
    await context.read<StudySessionProvider>().saveSession(
      topics: widget.selectedTopics,
      durationInSeconds: _totalSeconds,
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

              // Timer Display Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TimeCard(value: _formatTime(_hours), label: 'Hours'),
                  const SizedBox(width: 16),
                  _TimeCard(value: _formatTime(_minutes), label: 'Minutes'),
                  const SizedBox(width: 16),
                  _TimeCard(value: _formatTime(_seconds), label: 'Seconds'),
                ],
              ),

              const SizedBox(height: 48),

              // Control Buttons
              PrimaryButton(
                text: _isRunning ? 'Pause' : 'Start',
                onPressed: _startPauseTimer,
              ),

              const SizedBox(height: 12),

              SecondaryButton(text: 'Save & Reset', onPressed: _resetTimer),

              const SizedBox(height: 24),

              // Session Info
              Card(
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
                          Text('Total Time', style: AppTextStyles.bodySmall),
                          Text(
                            '${_formatTime(_hours)}:${_formatTime(_minutes)}:${_formatTime(_seconds)}',
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
