import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
class SPClassGameCarousel extends StatefulWidget {
  const SPClassGameCarousel({Key key}) : super(key: key);

  @override
  _SPClassGameCarouselState createState() => _SPClassGameCarouselState();
}

class _SPClassGameCarouselState extends State<SPClassGameCarousel> {
  List imageList =['https://i0.hdslb.com/bfs/article/f3fa363861ec64343e1a7587e725d97a40f75f86.jpg@1320w_2504h.webp',
  'https://i0.hdslb.com/bfs/article/249b60fe112fcb0594335cd63764a424e7d1ec7f.jpg@1320w_1844h.webp',
  'https://i0.hdslb.com/bfs/article/348816013ebf8229e1f1e2af1b335d5b52c7227a.jpg@1320w_1870h.webp'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(150),
      child: Swiper(
        itemCount: imageList.length,
        autoplay: true,
        duration:1500 ,
        viewportFraction: 0.8,
        scale: 0.8,
        itemBuilder: (context,item){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: width(5)),
            width: width(300),
            decoration: BoxDecoration(
              borderRadius:BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(
                    imageList[item],
                ),
                  fit: BoxFit.fill
              )
            ),
          );
        },
      ),
    );
  }
}
