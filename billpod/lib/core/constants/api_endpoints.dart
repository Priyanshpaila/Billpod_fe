class ApiEndpoints {
  // Base URLs
  static const String baseUrl =
      'http://192.168.13.74:5000'; // change for production
  static const String authBase = '$baseUrl/api/auth';
  static const String userBase = '$baseUrl/api/user';
  static const String groupBase = '$baseUrl/api/groups';
  static const String expenseBase = '$baseUrl/api/expenses';
  static const String settlementBase = '$baseUrl/api/settlements';
  static const String activityBase = '$baseUrl/api/activity';
  static const String notificationBase = '$baseUrl/api/notifications';
  static const String reportBase = '$baseUrl/api/reports';
  static const String imageBase = '$baseUrl/api/images';

  // Auth
  static const String login = '$authBase/login';
  static const String signup = '$authBase/signup';
  static const String logout = '$authBase/logout';

  // User
  static const String userProfile = '$userBase/me';

  // Groups
  static const String createGroup = groupBase;
  static const String fetchGroups = groupBase;
  static const String addMember = '$groupBase/add-member';
  static String archiveGroup(String id) => '$groupBase/$id/archive';

  // Expenses
  static const String addExpense = expenseBase;
  static String getGroupExpenses(String groupId) =>
      '$expenseBase/group/$groupId';
  static String deleteExpense(String expenseId) => '$expenseBase/$expenseId';
  static const String searchExpenses = '$expenseBase/search';

  // Settlements
  static const String addSettlement = settlementBase;
  static String getGroupSettlements(String groupId) =>
      '$settlementBase/group/$groupId';

  // Activities
  static const String logActivity = activityBase;
  static String getGroupActivities(String groupId) =>
      '$activityBase/group/$groupId';

  // Notifications
  static const String getNotifications = notificationBase;
  static const String sendNotification = notificationBase;
  static String markNotificationRead(String id) => '$notificationBase/$id/read';

  // Reports
  static String getGroupReport(String groupId) => '$reportBase/group/$groupId';
  static String exportGroupReportCSV(String groupId) =>
      '$reportBase/group/$groupId/export-csv';

  // Images
  static const String uploadImage = '$imageBase/upload';
  static String getImage(String id) => '$imageBase/$id';
}
