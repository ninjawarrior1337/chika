import 'package:chika/RedditPost.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RedditListView extends StatefulWidget {
  final Stream<UserContent> initalObservable;
  final Stream<UserContent> Function(String postOffset) loadMoreObservable;

  RedditListView({@required this.initalObservable, @required this.loadMoreObservable});

  @override
  _RedditListViewState createState() => _RedditListViewState();
}

class _RedditListViewState extends State<RedditListView> {

  BehaviorSubject<UserContent> _redditObservable;
  ScrollController _scrollController;

  List<Submission> posts = [];

  _scrollListener() {
    if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-1000) {
      try {
        _redditObservable.addStream(widget.loadMoreObservable(posts.last.fullname));
      }
      catch (e) {

      }
    }
  }

  @override
  void initState() {
    super.initState();
    _redditObservable = BehaviorSubject();
    _redditObservable.addStream(widget.initalObservable);
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
    _redditObservable.listen((data) {
      if(mounted)
        setState(() {
          if(data != null)
            posts.add(data);
        });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _redditObservable.drain();
    await _redditObservable.close();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (ctx, index) {
      return RedditPost(posts[index]);
    }, itemCount: posts.length, controller: _scrollController,);
  }
}
