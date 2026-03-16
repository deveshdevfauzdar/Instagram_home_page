class Story {
  const Story({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.isSeen,
  });

  final String id;
  final String username;
  final String avatarUrl;
  final bool isSeen;
}
