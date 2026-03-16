import 'package:flutter/material.dart';

class InstagramTopBar extends StatelessWidget implements PreferredSizeWidget {
  const InstagramTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFF000000),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 12,
      title: const Text(
        'Instagram',
        style: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 30,
          fontWeight: FontWeight.w500,
          height: 1,
          letterSpacing: -0.8,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
            size: 27,
            color: Color(0xFFFAFAFA),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 25,
            color: Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
