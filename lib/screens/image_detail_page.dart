import 'package:ataturk_resimleri/admob/admob_manager.dart';
import 'package:ataturk_resimleri/screens/fullscreen_image_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int adsCounter = 0;

class ImageDetailPage extends StatefulWidget {
  final int index;
  final int orderValue;

  const ImageDetailPage({this.index, this.orderValue}) : super();

  @override
  _ImageDetailPageState createState() =>
      _ImageDetailPageState(index, orderValue);
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int index;
  final int orderValue;
  InterstitialAd myInterstitial;
  bool showAds = adsCounter % 3 == 0 ? true : false;
  bool hasShownAds = false;

  _ImageDetailPageState(this.index, this.orderValue);

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: MobileAdTargetingInfo(
        keywords: <String>['mirsaiddev', 'ataturk resimleri'],
        contentUrl: 'https://flutter.io',
        childDirected: false,
        testDevices: <String>["YOUR TEST ID"],
      ),
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        } else if (event == MobileAdEvent.opened) {
          hasShownAds = true;
        }
      },
    );
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    super.initState();
    if (showAds) {
      _initAdMob();
      myInterstitial = buildInterstitialAd()
        ..load()
        ..show();
    }
    adsCounter++;
  }

  @override
  void dispose() {
    if (hasShownAds) {
      myInterstitial.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int limit;
    return Scaffold(
      appBar: AppBar(
        title: Text("Atatürk Resimleri",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: orderValue == 1
            ? firestore.collection("resimler").orderBy("year").snapshots()
            : firestore
                .collection("resimler")
                .orderBy("year", descending: true)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          limit = snapshot.data.docs.length;
          return ListView(
            physics: ScrollPhysics(),
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.black),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    MyImage(url: snapshot.data.docs[index]["url"]),
                    FullScreenButton(url: snapshot.data.docs[index]["url"]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  snapshot.data.docs[index]["title"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 150),
            ],
          );
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    //? index azaltma
                    if (index != 0) {
                      index--;
                    }
                  });
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                //?index artirma
                setState(() {
                  if (index != limit - 1) {
                    index++;
                  }
                });
              },
              backgroundColor: Colors.black,
              child: Icon(Icons.keyboard_arrow_right, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenButton extends StatelessWidget {
  const FullScreenButton({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    FullScreenImagePage(url: url),
              ),
            );
          },
          splashColor: Colors.grey,
          child: CircleAvatar(
            radius: 22,
            child: Icon(Icons.fullscreen, color: Colors.black),
            backgroundColor: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
      bottom: 0,
      right: 0,
    );
  }
}

class MyImage extends StatelessWidget {
  const MyImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        child: Hero(
          tag: "a",
          child: Image.network(
            url,
            width: double.infinity,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
    );
  }
}
