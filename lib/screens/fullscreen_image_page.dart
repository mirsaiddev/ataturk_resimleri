import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImagePage extends StatefulWidget {
  final String url;

  const FullScreenImagePage({Key key, this.url}) : super(key: key);
  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  @override
  Widget build(BuildContext context) {
    String url = widget.url;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Hero(
            tag: "a",
            child: PhotoView(
              imageProvider: NetworkImage(url),
            ),
          ),
        ),
      ),
    );
  }
}
