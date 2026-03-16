import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../domain/models/post.dart';
import 'feature_snackbar.dart';
import 'network_image_tile.dart';
import 'pinch_zoomable_image.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onToggleLike,
    required this.onToggleSave,
  });

  final Post post;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleSave;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final PageController _pageController;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: NetworkImageTile(imageUrl: post.userAvatarUrl),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                    Text(
                      post.location,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFA8A8A8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: Color(0xFFF5F5F5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: post.mediaUrls.length == 1
                ? PinchZoomableImage(
                    imageUrl: post.mediaUrls.first,
                    onDoubleTap: widget.onToggleLike,
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: post.mediaUrls.length,
                    onPageChanged: (int value) =>
                        setState(() => _activePage = value),
                    itemBuilder: (BuildContext context, int index) {
                      return PinchZoomableImage(
                        imageUrl: post.mediaUrls[index],
                        onDoubleTap: widget.onToggleLike,
                      );
                    },
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 6, 6),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: widget.onToggleLike,
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked
                      ? const Color(0xFFED4956)
                      : const Color(0xFFF5F5F5),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () =>
                    showFeatureComingSoonSnackBar(context, 'Comments'),
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  size: 25,
                  color: Color(0xFFF5F5F5),
                ),
              ),
              IconButton(
                onPressed: () =>
                    showFeatureComingSoonSnackBar(context, 'Share'),
                icon: const Icon(
                  Icons.send_outlined,
                  size: 24,
                  color: Color(0xFFF5F5F5),
                ),
              ),
              if (post.mediaUrls.length > 1)
                Expanded(
                  child: Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activePage,
                      count: post.mediaUrls.length,
                      effect: const WormEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        spacing: 4,
                        dotColor: Color(0xFFC9CCD2),
                        activeDotColor: Color(0xFF3897F0),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              IconButton(
                onPressed: widget.onToggleSave,
                icon: Icon(
                  post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xFFF5F5F5),
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Liked by ${post.likedBy} and ${post.likeCount} others',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 13,
                height: 1.3,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: '${post.username} ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
          child: Text(
            post.timeAgo,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFA8A8A8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(height: 1, thickness: 0.7, color: Color(0xFF262626)),
      ],
    );
  }
}
