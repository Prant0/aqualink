import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_aqualink/model/model.dart';
import 'package:new_aqualink/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchHomeData();
  }

  List<Model> allData = [];
  List<Sprite> images = [];
  Model? model;
  Sprite? sprite;

  fetchHomeData() async {
    var link = "https://pokeapi.co/api/v2/pokemon/2";
    var responce = await http.get(Uri.parse(link));
    var data = jsonDecode(responce.body);
    print("Next data is :${data["sprites"]["back_default"]}");
    model = Model(
        id: data["id"],
        weight: data["weight"],
        height: data["height"],
        types1: data["types"][0]["type"]["name"],
        types2: data["types"][1]["type"]["name"],
        title: data["name"]);
    sprite = Sprite(
      back_default: data["sprites"]["back_default"],
      back_shiny: data["sprites"]["back_shiny"],
      front_default: data["sprites"]["front_default"],
      front_shiny: data["sprites"]["front_shiny"],
    );

    setState(() {
      allData.add(model!);
      images.add(sprite!);
    });
    print("all data are${allData.length} ${images.length}");
  }

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: images.isEmpty
          ? Center(child: spinkit)
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (value, CarouselPageChangedReason) {
                            setState(() {
                              currentindex = value;
                            });
                          },
                          aspectRatio: 23 / 15,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          viewportFraction: 0.4,
                        ),
                        items: [
                          customCard(0, "${images[0].front_shiny}"),
                          customCard(1, "${images[0].front_default}"),
                          customCard(2, "${images[0].back_default}"),
                          customCard(3, "${images[0].back_shiny}"),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Text(
                            "${allData[0].title}",
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Height: ${allData[0].height}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Weight: ${allData[0].weight}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Type: ${allData[0].types1} / ${allData[0].types2}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    flex: 5,
                  )
                ],
              ),
            ),
    );
  }

  Container customCard(int index, String img) {
    return Container(
        height: 700,
        width: double.infinity,
        //padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 3,
              color: currentindex == index
                  ? Color(0xff64FFDA)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: currentindex == index ? 0 : 2,
              blurRadius: 0,
              offset: Offset(0,
                  currentindex == index ? 2 : 0), // changes position of shadow
            ),
          ],
        ),
        child: ListView(
          children: [
            Image.network(
              "$img",
              fit: BoxFit.fitWidth,
            ),
            currentindex == index
                ? Center(
                    child: Text(
                    "#${allData[0].id}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ))
                : SizedBox(
                    height: 0,
                  ),
          ],
        ));
  }
}
