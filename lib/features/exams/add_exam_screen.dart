import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import 'widgets/exam_fields.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/topics_section.dart';

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
  final List<String> _topics = [];
  final _topicController = TextEditingController();

  @override
  void dispose() {
    _examNameController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
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
    if (_topicController.text.trim().isNotEmpty) {
      setState(() {
        _topics.add(_topicController.text.trim());
        _topicController.clear();
      });
    }
  }

  void _removeTopic(int index) {
    setState(() {
      _topics.removeAt(index);
    });
  }

  void _saveExam() {
    if (_formKey.currentState!.validate()) {
      // Save exam logic here
      context.go('/exams');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Add Exam', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ExamNameField(controller: _examNameController),
                const SizedBox(height: 20),
                SubjectField(controller: _subjectController),
                const SizedBox(height: 20),
                Text('Exam Date', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                DatePickerField(selectedDate: _selectedDate, onTap: () => _selectDate(context)),
                const SizedBox(height: 24),
                TopicsSection(
                  topics: _topics,
                  topicController: _topicController,
                  onAddTopic: _addTopic,
                  onRemoveTopic: _removeTopic,
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Save Exam', onPressed: _saveExam),
                const SizedBox(height: 12),
                SecondaryButton(text: 'Cancel', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}