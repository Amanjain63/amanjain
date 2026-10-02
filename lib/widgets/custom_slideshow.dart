import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomSlideshow extends StatelessWidget {
  final List<String> img_url;
  CustomSlideshow({super.key, required this.img_url});
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlayCurve: Curves.easeInExpo,
        autoPlay: true,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        enlargeFactor: 0.1
      ),
      items: img_url.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.amber,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                  child: Image.network(i, fit: BoxFit.cover)),
            );
          },
        );
      }).toList(),
    );
  }
}
