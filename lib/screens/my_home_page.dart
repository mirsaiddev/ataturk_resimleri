import 'package:ataturk_resimleri/models/image_card.dart';
import 'package:ataturk_resimleri/models/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masonry_grid/masonry_grid.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int orderValue = 1;
  int limit = 15;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        increaseLimit();
      } else if (controller.position.pixels ==
          controller.position.minScrollExtent) {
        setState(() {
          limit = 15;
        });
      }
    });
  }

  void increaseLimit() {
    setState(() {
      limit = limit + 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Atatürk Resimleri",
          style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            initialValue: orderValue,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Yıla göre (artan)"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Yıla göre (azalan)"),
              )
            ],
            icon: Icon(Icons.art_track),
            onSelected: (value) {
              setState(() {
                orderValue = value;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: orderValue == 1
            ? firestore
                .collection("resimler")
                .orderBy("year")
                .limit(limit)
                .snapshots()
            : firestore
                .collection("resimler")
                .orderBy("year", descending: true)
                .limit(limit)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGrid(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                column: 2,
                children: List.generate(
                  snapshot.data.docs.length,
                  (index) => ImageCard(
                    snapshot.data.docs[index]["url"],
                    snapshot.data.docs[index]["title"],
                    index,
                    orderValue,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: MyDrawer(),
    );
  }
}