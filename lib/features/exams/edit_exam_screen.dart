import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/edit_fields.dart';
import 'widgets/edit_topics.dart';
import 'widgets/exams_bottom_nav.dart';

class EditExamScreen extends StatefulWidget {
  final String examName;
  final String examDate;
  final int examProgress;

  const EditExamScreen({
    super.key,
    required this.examName,
    required this.examDate,
    required this.examProgress,
  });

  @override
  State<EditExamScreen> createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  late TextEditingController _examNameController;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late List<TextEditingController> _topicControllers;

  @override
  void initState() {
    super.initState();
    
    // Initialize with actual exam data
    _examNameController = TextEditingController(text: widget.examName);
    _dateController = TextEditingController(text: widget.examDate);
    
    // Determine subject and topics based on exam name
    String subject = _getSubjectFromExam(widget.examName);
    List<String> topics = _getTopicsForExam(widget.examName);
    
    _subjectController = TextEditingController(text: subject);
    _topicControllers = topics.map((topic) => TextEditingController(text: topic)).toList();
  }

  String _getSubjectFromExam(String examName) {
    if (examName.contains('Physics')) return 'Physics';
    if (examName.contains('Math')) return 'Mathematics';
    if (examName.contains('Chemistry')) return 'Chemistry';
    return 'General';
  }

  List<String> _getTopicsForExam(String examName) {
    if (examName.contains('Physics')) {
      return ['Kinematics & Dynamics', 'Work and Energy', 'Circular Motion', 'Thermodynamics'];
    } else if (examName.contains('Math')) {
      return ['Calculus', 'Linear Algebra', 'Differential Equations'];
    } else if (examName.contains('Chemistry')) {
      return ['Organic Chemistry', 'Thermochemistry', 'Chemical Bonding'];
    }
    return ['Topic 1', 'Topic 2', 'Topic 3'];
  }

  @override
  void dispose() {
    _examNameController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    for (var controller in _topicControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    // Handle save logic
    context.pop();
  }

  void _addTopic() {
    setState(() {
      _topicControllers.add(TextEditingController());
    });
  }

  void _removeTopic(int index) {
    if (_topicControllers.length > 1) {
      setState(() {
        _topicControllers[index].dispose();
        _topicControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
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
          child: Container(
            color: const Color(0xFFE5E7EB),
            height: 1,
          ),
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
                EditTopics(topicControllers: _topicControllers, onAddTopic: _addTopic),

                // Save Changes Button
                SizedBox(
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
                      shadowColor: const Color(0xFF2A7FF7).withOpacity(0.3),
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

                // Cancel Button
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