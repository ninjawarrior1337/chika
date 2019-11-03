import 'dart:ui' as prefix0;

import 'package:chika/redditViews/RedditFrontPage.dart';
import 'package:chika/redditViews/RedditListView.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';

import 'RedditPost.dart';
import 'api/oauth.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>
{
  List<Submission> posts = [];
  ScrollController scrollController;

  Reddit reddit;

  @override
  void initState() {
    super.initState();
    reddit = RedditClient().reddit;
  }

  @override
  Widget build(BuildContext context) {
    return RedditFrontPage();
  }
}