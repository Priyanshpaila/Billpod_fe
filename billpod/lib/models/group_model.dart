class GroupModel {
  final String id;
  final String name;
  final String description;
  final String groupType;
  final String currency;
  final bool isArchived;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.groupType,
    required this.currency,
    required this.isArchived,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      groupType: json['groupType'] ?? 'General',
      currency: json['currency'] ?? 'INR',
      isArchived: json['isArchived'] ?? false,
    );
  }
}
