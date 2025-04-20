import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTopCard extends StatelessWidget {
  const HomeTopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/vectors/home_top_card.svg'),
          Padding(
            padding: const EdgeInsets.only(left: 150, bottom: 31),
            child: Image.asset(
              'assets/images/home_artist.png',
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
