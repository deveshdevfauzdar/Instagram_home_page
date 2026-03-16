import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF111111),
      highlightColor: const Color(0xFF1F1F1F),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              if (index == 0) ...<Widget>[
                const SizedBox(height: 10),
                const _StoriesShimmer(),
                const SizedBox(height: 8),
              ],
              const _PostShimmer(),
            ],
          );
        },
      ),
    );
  }
}

class FeedPaginationShimmer extends StatelessWidget {
  const FeedPaginationShimmer({super.key, this.count = 2});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF111111),
      highlightColor: const Color(0xFF1F1F1F),
      child: Column(
        children: List<Widget>.generate(
          count,
          (int index) => const _PostShimmer(),
          growable: false,
        ),
      ),
    );
  }
}

class _StoriesShimmer extends StatelessWidget {
  const _StoriesShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                width: 66,
                height: 66,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 6),
              Container(width: 54, height: 8, color: Color(0xFF1A1A1A)),
            ],
          );
        },
      ),
    );
  }
}

class _PostShimmer extends StatelessWidget {
  const _PostShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 120, height: 11, color: Color(0xFF1A1A1A)),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(color: const Color(0xFF1A1A1A)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  color: const Color(0xFF1A1A1A),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 24,
                  height: 24,
                  color: const Color(0xFF1A1A1A),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 24,
                  height: 24,
                  color: const Color(0xFF1A1A1A),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  color: const Color(0xFF1A1A1A),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Container(height: 10, color: const Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }
}
