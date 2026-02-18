class Validators {
  static String? validateExamName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an exam name';
    }
    if (value.trim().length < 3) {
      return 'Exam name must be at least 3 characters';
    }
    return null;
  }

  static String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a subject';
    }
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    if (date.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }
    return null;
  }

  static String? validateTopicName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a topic name';
    }
    return null;
  }
}
