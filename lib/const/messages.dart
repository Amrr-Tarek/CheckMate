class Messages {
  static const String finish = "Checkmate!";
  static const String motivationToAddGoals =
      "Your next move starts here!\nAdd some goals and checkmate them!";
  static const String motivationToAddActivities =
      "Your next move starts here!\nAdd an activity and checkmate your Goals!";
  static const String addActivity = "Add New activity";
  static const String enterActivityDescription = "Enter activity description";
  static const String cancelButtonText = "Cancel";
  static const String addButtonText = "Add activity";
  static const String enterActivityInterval = "Enter time interval";
  static const String activityInputError =
      "please enter both description and interval correctly";
  static const String saveButtonText = "Save";
  static const String editActivity = "Edit";
  static String exceedWordLimit(wordLimit) {
    return "Please limit Your description to $wordLimit words.";
  }

  static const String tittle_And_Deadline_Required =
      "title and deadline are required.";
  static String exceedCharLimit(charLimit) {
    return "title must be less than $charLimit characters long.";
  }

  static const String invalid_deadline = "Invalid deadline format.";
  static const String subtask_deadline_before_goal_deadline =
      "Subtask's deadline must be before goal's deadline ";

  static const String NoUnCheckedGoals = "You have no unchecked goals at the moment. Stay ahead with Checkmate and set new goals to keep achieving!";
}
