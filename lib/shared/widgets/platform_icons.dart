import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlatformIcons extends StatelessWidget {
  final List<String> slugs;

  const PlatformIcons({super.key, required this.slugs});

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];
    for (var slug in slugs) {
      if (slug == 'pc') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.windows,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'playstation') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.playstation,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'xbox') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.xbox,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'nintendo') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.playstation,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'android') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.android,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'mac') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.apple,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'ios') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.mobile,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      } else if (slug == 'linux') {
        icons.add(
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: FaIcon(
              FontAwesomeIcons.linux,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        );
      }
    }
    if (icons.isEmpty) {
      icons.add(const Icon(Icons.gamepad, color: Color(0xFF9CA3AF), size: 16));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }
}
