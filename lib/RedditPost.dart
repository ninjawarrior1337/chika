import 'dart:convert';
import 'dart:math';
import 'dart:ui' as prefix0;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chika/ImageViewer.dart';
import 'package:chika/api/oauth.dart';
import 'package:chika/redditViews/SubredditPage.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
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
  var unescape = new HtmlUnescape();
  var userLiked;
  bool _shouldArtificiallyModifyLikes = false;

  void _upvote() {
    if(userLiked != true)
      setState(() {
        widget.submission.upvote();
        userLiked = true;
      });
    else
      _clearVote();

    _shouldArtificiallyModifyLikes = true;
  }

  void _downvote() {
    if(userLiked != false)
      setState(() {
        widget.submission.downvote();
        userLiked = false;
      });
    else
      _clearVote();

    _shouldArtificiallyModifyLikes = true;
  }

  void _clearVote() {
    setState(() {
      widget.submission.clearVote();
      userLiked = null;
    });

    _shouldArtificiallyModifyLikes = true;
  }

  int _getLikeCount() {
    var baseUpvotes = widget.submission.upvotes;
    if(_shouldArtificiallyModifyLikes)
      if(userLiked == true)
        return baseUpvotes+1;
      else
        return baseUpvotes-1;
    else
      return baseUpvotes;
  }

  void _navigateToSubreddit(String subName) {
    Navigator.push(context, MaterialPageRoute(
      builder: (ctx) {
        return SubredditPage(subName);
      }
    ));
  }

  @override
  void initState() {
    super.initState();
    userLiked = widget.submission.data["likes"];
  }

  @override
  Widget build(BuildContext context) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                unescape.convert(widget.submission.title),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: widget.submission.stickied ? Colors.greenAccent[700] : Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  widget.submission.over18 ? Text(" NSFW ", style: TextStyle(backgroundColor: Colors.red),) : Container(),
                  widget.submission.stickied ? Text(" STICKY ", style: TextStyle(backgroundColor: Colors.greenAccent),) : Container(),
                  widget.submission.url.toString().contains("gif") ? Text(" GIF ", style: TextStyle(backgroundColor: Colors.blueAccent),) : Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _navigateToSubreddit(widget.submission.subreddit.displayName),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "r/"+widget.submission.subreddit.displayName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
            ),
            !widget.submission.isSelf && widget.submission.preview.length > 0 ?
            Center(
              child: GestureDetector(
                onTap: () {
                  if(imageRegex.hasMatch(widget.submission.url.toString()))
                    Navigator.push(context, new PageRouteBuilder(pageBuilder: (ctx, anim, secAnim) => ImageViewer(widget.submission.url.toString()), opaque: false));
                  else
                    launch(widget.submission.url.toString());
                },
                child: Hero(
                  tag: widget.submission.url.toString(),
                  child: widget.submission.over18 ?
                    Image.asset("assets/nsfw.jpg")
                    :
                    CachedNetworkImage(
                    imageUrl: widget.submission.preview.first.resolutions.last.url.toString(),
                    placeholder: (ctx, url) => Stack(
                      children: <Widget>[
                        Image.memory(
                            kTransparentImage,
                            height: 200,
                        ),
                        Center(
                            child: CircularProgressIndicator()
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ) : null,
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700]
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: _upvote,
                    icon: Icon(Icons.arrow_upward),
                    color: userLiked == true ? Colors.orange : Colors.grey
                  ),
                  Text(NumberFormat.compact().format(_getLikeCount())),
                  IconButton(
                      onPressed: _downvote,
                      icon: Icon(Icons.arrow_downward),
                      color: userLiked == false ? Colors.lightBlue : Colors.grey
                  ),
                ],
              ),
            )
          ].where((o) {return o != null;}).toList(),
        ),
      );
  }
}