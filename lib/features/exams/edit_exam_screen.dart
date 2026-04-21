import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/models/exam.dart';
import 'widgets/edit_fields.dart';
import 'widgets/edit_topics.dart';
import 'widgets/exam_fields.dart';

class EditExamScreen extends StatefulWidget {
  final String examId;

  const EditExamScreen({super.key, required this.examId});

  @override
  State<EditExamScreen> createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _examNameController;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late TextEditingController _targetHoursController;
  late List<TextEditingController> _topicControllers;
  Exam? _exam;
  bool _isSaving = false;

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

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
    if (!_formKey.currentState!.validate()) return;

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
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Edit exam',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Update your exam plan',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 26,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Refine the exam details, topics, and study target so your preparation stays accurate.',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    child: EditFields(
                      examNameController: _examNameController,
                      subjectController: _subjectController,
                      dateController: _dateController,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EditTopics(
                          topicControllers: _topicControllers,
                          onAddTopic: _addTopic,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Target Study Hours',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Adjust the time you want to dedicate before the exam.',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _targetHoursController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: buildExamFieldDecoration(
                            hintText: 'e.g. 10',
                            suffixText: 'hours',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter target hours';
                            }
                            final hours = double.tryParse(value.trim());
                            if (hours == null || hours <= 0) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          text: 'Save Changes',
                          onPressed: _handleSave,
                        ),
                  const SizedBox(height: 12),
                  SecondaryButton(text: 'Cancel', onPressed: () => context.pop()),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
