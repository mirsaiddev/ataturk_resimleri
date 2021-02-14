import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  openInstagram() async {
    String url = "https://www.instagram.com/mirsaiddev/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openGooglePlay() async {
    String url =
        "https://play.google.com/store/apps/details?id=com.ataturk.mirsaiddev";
    if (await canLaunch(url)) {
      
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Header(),
            ListTile(
              leading: Icon(Icons.star),
              title: Text(
                "Play Store'da Puan Ver",
              ),
              onTap: () {
                openGooglePlay();
              },
            ),
            ListTile(
              leading: Image.network(
                "https://cdn.icon-icons.com/icons2/1826/PNG/512/4202090instagramlogosocialsocialmedia-115598_115703.png",
                height: 25,
                color: Colors.grey,
              ),
              title: Text(
                "Bize Ulaşmak İçin",
              ),
              onTap: () {
                openInstagram();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      currentAccountPicture: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey,
        ),
        child: Image.asset("assets/app_image.png", fit: BoxFit.cover),//!buraya resim getir
      ),
      accountName: Text(
        "Atatürk Resimleri",
        style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      accountEmail: Text("Tarih ve Yer Bilgileri ile"),
    );
  }
}
