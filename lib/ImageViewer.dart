import 'package:chika/main.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  String imageUrl;
  ImageViewer(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.black87,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.save),
            )
          ],
        ),
        Expanded(
          child: PhotoView(
            loadingChild: Stack(
              children: <Widget>[
                Container(
                    color: Colors.black87,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
              ],
            ),
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.covered * 1.8,
            heroAttributes: PhotoViewHeroAttributes(
                tag: imageUrl,
                transitionOnUserGestures: true
            ),
            backgroundDecoration: BoxDecoration(
                color: Colors.black87
            ),
            imageProvider: NetworkImage(
                imageUrl
            ),
          ),
        ),
      ],
    );
  }
}