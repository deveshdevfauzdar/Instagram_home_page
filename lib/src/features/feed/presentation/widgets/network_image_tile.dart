import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageTile extends StatelessWidget {
  const NetworkImageTile({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 160),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (BuildContext context, String url) {
        return Container(color: const Color(0xFF151515));
      },
      errorWidget: (BuildContext context, String url, Object error) {
        return Container(
          color: const Color(0xFF151515),
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image_outlined,
            color: Color(0xFF8E8E8E),
          ),
        );
      },
    );
  }
}
