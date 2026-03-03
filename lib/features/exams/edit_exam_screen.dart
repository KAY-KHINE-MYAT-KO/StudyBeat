import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/models/exam.dart';
import 'widgets/edit_fields.dart';
import 'widgets/edit_topics.dart';
import 'widgets/exams_bottom_nav.dart';

class EditExamScreen extends StatefulWidget {
  final String examId;

  const EditExamScreen({super.key, required this.examId});

  @override
  State<EditExamScreen> createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  late TextEditingController _examNameController;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late TextEditingController _targetHoursController;
  late List<TextEditingController> _topicControllers;
  Exam? _exam;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _exam = context.read<ExamProvider>().getExamById(widget.examId);

    if (_exam != null) {
      _examNameController = TextEditingController(text: _exam!.name);
      _subjectController = TextEditingController(text: _exam!.subject);
      _dateController = TextEditingController(
        text: DateFormat('MMM d, yyyy').format(_exam!.examDate),
      );
      _targetHoursController = TextEditingController(
        text: _exam!.targetStudyHours.toString(),
      );
      _topicControllers = _exam!.topics
          .map((topic) => TextEditingController(text: topic))
          .toList();
    } else {
      _examNameController = TextEditingController();
      _subjectController = TextEditingController();
      _dateController = TextEditingController();
      _targetHoursController = TextEditingController(text: '10');
      _topicControllers = [TextEditingController()];
    }
  }

  @override
  void dispose() {
    _examNameController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _targetHoursController.dispose();
    for (var controller in _topicControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_exam == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedTopics = _topicControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final updatedExam = _exam!.copyWith(
        name: _examNameController.text.trim(),
        subject: _subjectController.text.trim(),
        topics: updatedTopics,
        targetStudyHours:
            double.tryParse(_targetHoursController.text.trim()) ??
            _exam!.targetStudyHours,
        synced: false,
      );

      await context.read<ExamProvider>().updateExam(updatedExam);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addTopic() {
    setState(() {
      _topicControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_exam == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Edit Exam'),
        ),
        body: const Center(child: Text('Exam not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Exam',
          style: AppTextStyles.appBarTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E7EB), height: 1),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditFields(
                  examNameController: _examNameController,
                  subjectController: _subjectController,
                  dateController: _dateController,
                ),
                const SizedBox(height: 24),
                EditTopics(
                  topicControllers: _topicControllers,
                  onAddTopic: _addTopic,
                ),

                const SizedBox(height: 16),
                Text(
                  'Target Study Hours',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _targetHoursController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 10',
                    suffixText: 'hours',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A7FF7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Save Changes',
                            style: AppTextStyles.button.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2A7FF7),
                      side: const BorderSide(
                        color: Color(0xFF2A7FF7),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2A7FF7),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ExamsBottomNav(),
    );
  }
}
