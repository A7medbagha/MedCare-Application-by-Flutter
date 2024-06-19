import 'package:flutter/material.dart';

class CatigoryW extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  CatigoryW({
    required this.image,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 177,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 7,
            ),
            Image.asset(
              image,
              width: 120,
              height: 120,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
