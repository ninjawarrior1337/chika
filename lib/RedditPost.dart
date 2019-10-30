import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chika/ImageViewer.dart';
import 'package:chika/TransparentMaterialPageRoute.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class RedditPost extends StatefulWidget{
  final Submission submission;
  RedditPost(this.submission);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RedditPostState();
  }
}

class RedditPostState extends State<RedditPost> {
  
  RegExp imageRegex = RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
  
  @override
  Widget build(BuildContext context) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                widget.submission.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                "r/"+widget.submission.subreddit.displayName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.orange[600]
                ),
              ),
            ),
            !widget.submission.isSelf ?
            Center(
              child: GestureDetector(
                onTap: () {
                  if(imageRegex.hasMatch(widget.submission.url.toString()))
                    Navigator.push(context, new PageRouteBuilder(pageBuilder: (ctx, anim, secAnim) => ImageViewer(widget.submission.url.toString()), opaque: false));
                  else
                    launch(widget.submission.url.toString());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: widget.submission.url.toString(),
                    child: CachedNetworkImage(
                      imageUrl: widget.submission.preview[0].resolutions.last.url.toString(),
                      placeholder: (ctx, url) => Column(
                        children: <Widget>[
                          Container(
                            height: widget.submission.preview[0].resolutions.last.height.toDouble(),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ) : null
          ].where((o) {return o != null;}).toList(),
        ),
      );
  }
}