import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/providers/exam_provider.dart';
import 'widgets/exam_fields.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/edit_topics.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _examNameController = TextEditingController();
  final _subjectController = TextEditingController();
  DateTime? _selectedDate;
  late List<TextEditingController> _topicControllers;
  final _targetHoursController = TextEditingController(text: '10');
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
    _topicControllers = [TextEditingController()];
  }

  @override
  void dispose() {
    _examNameController.dispose();
    _subjectController.dispose();
    _targetHoursController.dispose();
    for (var controller in _topicControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTopic() {
    setState(() {
      _topicControllers.add(TextEditingController());
    });
  }

  Future<void> _saveExam() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an exam date.')),
      );
      return;
    }

    // Extract topics from controllers, filtering out empty ones
    final topics = _topicControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    setState(() => _isSaving = true);

    try {
      await context.read<ExamProvider>().addExam(
        name: _examNameController.text.trim(),
        subject: _subjectController.text.trim(),
        examDate: _selectedDate!,
        topics: topics,
        targetStudyHours:
            double.tryParse(_targetHoursController.text.trim()) ?? 10.0,
      );

      if (mounted) context.go('/exams');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save exam: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Exam',
          style: AppTextStyles.appBarTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
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
                            'New exam',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Set up an exam you want to track',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 26,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add the core details, exam date, topics, and a realistic study target so your progress stays organized.',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exam details',
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Start with the basic information for this exam.',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        ExamNameField(controller: _examNameController),
                        const SizedBox(height: 20),
                        SubjectField(controller: _subjectController),
                        const SizedBox(height: 20),
                        Text(
                          'Exam Date',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DatePickerField(
                          selectedDate: _selectedDate,
                          onTap: () => _selectDate(context),
                        ),
                      ],
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
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Set a target you want to reach before exam day.',
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
                      : PrimaryButton(text: 'Save Exam', onPressed: _saveExam),
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
