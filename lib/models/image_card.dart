import 'package:ataturk_resimleri/screens/image_detail_page.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String url;
  final String title;
  final int index;
  final int orderValue;

  const ImageCard(this.url, this.title, this.index, this.orderValue) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.grey,
          child: ClipRRect(
            
            borderRadius: BorderRadius.circular(14.0),
            child: Image.network(url),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageDetailPage(
                  index: index,
                  orderValue: orderValue,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 6),
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: title,
              style: DefaultTextStyle.of(context).style,
            ),
          ),
        ),
      ],
    );
  }
}
