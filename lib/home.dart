import 'dart:ui' as prefix0;

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
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
  Stream<UserContent> redditStream;

  Reddit reddit;

  void _scrollListener() {
//    if(scrollController.position.extentAfter > scrollController.position.maxScrollExtent-50) {
//      redditStream = reddit.front.best(limit: 10, after: posts.last.fullname);
//    }
  }

  @override
  void initState() {
    super.initState();
    reddit = RedditClient().reddit;
    scrollController = new ScrollController()
      ..addListener(_scrollListener);
    redditStream = reddit.front.best(limit: 100);
    redditStream.listen((data) {
//      print(data);
      setState(() {
        posts.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chika"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => setState(() {}),
            )
          ],
        ),
        drawer: new Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange[800],
                      Colors.orange[500],
                    ],
                  )
                ),
                child: Row(
                  children: <Widget>[
                    FutureBuilder(
                      future: reddit.user.me(),
                      builder: (ctx, AsyncSnapshot<Redditor> snapshot) {
                        if(snapshot.hasData)
                          return Container(
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.network(
                                snapshot.data.iconImg,
                              ),
                            ),
                          );
                        else
                          return Image.memory(kTransparentImage);
                      },
                    ),
                    FutureBuilder(
                      future: reddit.user.me(),
                      builder: (ctx, AsyncSnapshot<Redditor> snapshot) {
                        if(snapshot.hasData)
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.displayName, 
                              style: TextStyle(
                                fontSize: 20
                              )
                            ),
                          );
                        else
                          return Text("Bruh");
                      },
                    ),
                  ],
                )
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text("Goto Subreddit"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(itemBuilder: (ctx, index) {
          return RedditPost(posts[index]);
        }, itemCount: posts.length, controller: scrollController)
    );
  }
}