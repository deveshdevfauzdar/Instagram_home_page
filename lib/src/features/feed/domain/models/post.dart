class Post {
  const Post({
    required this.id,
    required this.username,
    required this.userAvatarUrl,
    required this.location,
    required this.mediaUrls,
    required this.caption,
    required this.likeCount,
    required this.likedBy,
    required this.timeAgo,
    this.isLiked = false,
    this.isSaved = false,
  });

  final String id;
  final String username;
  final String userAvatarUrl;
  final String location;
  final List<String> mediaUrls;
  final String caption;
  final int likeCount;
  final String likedBy;
  final String timeAgo;
  final bool isLiked;
  final bool isSaved;

  Post copyWith({
    String? id,
    String? username,
    String? userAvatarUrl,
    String? location,
    List<String>? mediaUrls,
    String? caption,
    int? likeCount,
    String? likedBy,
    String? timeAgo,
    bool? isLiked,
    bool? isSaved,
  }) {
    return Post(
      id: id ?? this.id,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      location: location ?? this.location,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
      timeAgo: timeAgo ?? this.timeAgo,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
