import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
                // Exam Name Field
                Text(
                  'Exam Name',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _examNameController,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., Physics Midterm',
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Subject Field
                Text(
                  'Subject',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _subjectController,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., Physics',
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Date Field
                Text(
                  'Date',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dateController,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Feb 20, 2024',
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF2A7FF7),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Add Topics Section
                Text(
                  'Add Topics',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Topics List
                ..._topicControllers.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: entry.value,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a topic...',
                        hintStyle: AppTextStyles.body.copyWith(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: Center(
                            widthFactor: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2A7FF7),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1D5DB),
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 12),

                // Add Another Topic Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _addTopic,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2A7FF7),
                      side: const BorderSide(
                        color: Color(0xFF2A7FF7),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      '+ Add Another Topic',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2A7FF7),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Dashboard
              InkWell(
                onTap: () => context.go('/dashboard'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dashboard_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dashboard',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Exams (Active)
              InkWell(
                onTap: () => context.go('/exams'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: const Color(0xFF2A7FF7),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Exams',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF2A7FF7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Timer
              InkWell(
                onTap: () => context.go('/timer-select'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Timer',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
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