import 'package:flutter/material.dart';

class ShimmerNewsTile extends StatefulWidget {
  const ShimmerNewsTile({super.key});

  @override
  _ShimmerNewsTileState createState() => _ShimmerNewsTileState();
}

class _ShimmerNewsTileState extends State<ShimmerNewsTile> {
  bool isLightTheme = true;
  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft:
          Radius.circular(10),bottomRight: Radius.circular(10)
        ),
      ),
      margin: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.bottomCenter,
        decoration:const  BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 16,
              width: (MediaQuery.of(context).size.width) / 3,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10,
                  width: 30,
                  color: Colors.grey[300],
                ),
                Container(
                  height: 10,
                  width: 20,
                  color: Colors.grey[300],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
