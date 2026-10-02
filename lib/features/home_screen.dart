import 'package:flutter/material.dart';
import 'package:flutterapplications/widgets/custom_slideshow.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> images = ["https://cypersystems.com/wp-content/uploads/2022/12/Flutter-1-768x416.jpg","https://i.ytimg.com/vi/npYMyOueX70/maxresdefault.jpg"];
    String avtarImage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTdPrMVus7n0i5ycvzPGlud7_k-tV3AwScKRtylfX21w&s=10";
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "QUIZBIT 2.0",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      body:Column(
        children: [
          CustomSlideshow(img_url: images,),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This Week Superstart", style: TextStyle(fontWeight:FontWeight.bold,fontSize: 22)),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(radius: 45,backgroundImage: NetworkImage(avtarImage),),
                    CircleAvatar(radius: 45,backgroundImage: NetworkImage(avtarImage),),
                    CircleAvatar(radius: 45,backgroundImage: NetworkImage(avtarImage),),
                    CircleAvatar(radius: 45,backgroundImage: NetworkImage(avtarImage),),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Weekly Dhamaka", style:TextStyle(fontSize:23,fontWeight: FontWeight.w600),),
                  Text("More")
                ],
              ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
